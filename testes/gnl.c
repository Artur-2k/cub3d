#include "cub3d.h"

int main()
{
	int fd = open("./teste", O_RDONLY);

	if (fd < 0)
		return (1);

	char *line;
	while (true)
	{
		line = get_next_line(fd);
		if (!line)
			break ;
/* 		if (ft_strcmp(line, "malucos\n") == 0)
		{
			free(line);
			break ;
		} */
		printf("%s", line);
		fflush(stdout);

		free(line);
	}
	printf("\n");

	char *line2 = get_next_line(fd);
	printf("%s\n", line2);
	printf("\n");
	return (0);
}