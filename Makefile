# Binary
NAME = cub3d

# Compiler
CC = cc
IFLAGS = -I$(INC_DIR) -I$(MINILIBX_DIR) -I$(LIBFT_DIR)
CFLAGS = -Wall -Wextra -Werror -g
LFLAGS = -L$(LIBFT_DIR) -L$(MINILIBX_DIR) -lft -lmlx -lX11 -lXext -lm

#sanitize
#CFLAGS = -I$(INC_DIR) -I$(LIBFT_DIR) -Wall -Wextra -Werror -g -fsanitize=address -fsanitize=leak -fsanitize=undefined -fno-omit-frame-pointer
VG = valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --log-file=leaks.log
# --track-fds=all

# Color variables
RED = \033[0;31m
GRN = \033[0;32m
YEL = \033[0;33m
BLU = \033[0;34m
MAG = \033[0;35m
CYN = \033[0;36m
WHT = \033[0;37m
RES = \033[0m

# Directories
INC_DIR = inc/
LIB_DIR = lib/
LIBFT_DIR = $(LIB_DIR)libft/
MINILIBX_DIR = $(LIB_DIR)minilibx-linux/
SRC_DIR = src/
OBJ_DIR = obj/

# Files
MAIN_FILE = $(SRC_DIR)cub3d.c
LIBFT = $(LIBFT_DIR)libft.a
MINILIBX = $(MINILIBX_DIR)libmlx.a
# Find all .c files in src/ and its subdirectories
SRC_FILES := $(shell find $(SRC_DIR) -name '*.c')
# Create object file paths
OBJ_FILES := $(patsubst $(SRC_DIR)%.c,$(OBJ_DIR)%.o,$(SRC_FILES))

TOTAL_FILES := $(words $(SRC_FILES))
COMPILED_FILES := $(shell if [ -d "$(OBJ_DIR)" ]; then find $(OBJ_DIR) -name "*.o" | wc -l; else echo 0; fi)

# Phony targets
.PHONY: all clean fclean re

# Rules
all: $(NAME)

$(NAME): $(LIBFT) $(MINILIBX) $(OBJ_FILES) | $(OBJ_DIR)
	$(CC) $(IFLAGS) $(CFLAGS) $(OBJ_FILES) $(LFLAGS) -o $@
	@printf "$(GRN)➾ Compilation progress: $$(echo "$(shell find $(OBJ_DIR) -name "*.o" | wc -l) $(TOTAL_FILES)" | awk '{printf "%.2f", $$1/$$2 * 100}')%% $(RES)\r"
	@echo "\n$(GRN)➾ [ ${NAME} ] created$(RES)"

$(LIBFT):
	@$(MAKE) --silent -C $(LIBFT_DIR)

$(MINILIBX):
	@$(MAKE) --silent -C $(MINILIBX_DIR)

$(OBJ_DIR)%.o: $(SRC_DIR)%.c | $(OBJ_DIR)
	@mkdir -p $(@D)
	@$(CC) $(IFLAGS) $(CFLAGS) -c $< -o $@
	@printf "$(GRN)➾ Compilation progress: $$(echo "$(shell find $(OBJ_DIR) -name "*.o" | wc -l) $(TOTAL_FILES)" | awk '{printf "%.2f", $$1/$$2 * 100}')%%$(RES)\r"

$(OBJ_DIR):
	@mkdir -p $@

clean:
	@$(MAKE) --silent -C $(LIBFT_DIR) clean
	@rm -rf $(OBJ_DIR)
	@echo "${RED}➾ Cleaned the workspace${RES}"

fclean: clean
	@$(MAKE) --silent -C $(LIBFT_DIR) fclean
	@rm -f $(NAME)
	@rm -f leaks.log
	@rm -f leaks-old.log
	@echo "${RED}➾ Fully cleaned the workspace${RES}"

re: fclean all

#Debugging
leaks: all
	@if [ -f leaks.log ]; then mv leaks.log leaks-old.log; fi
	$(VG) ./$(NAME)
