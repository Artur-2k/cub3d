#include "cub3d.h"

#define WIN_H 800
#define WIN_L 1000
#define CELL_LEN 10

typedef struct s_image
{
	void	*img_ptr;
	char	*img_addr;
	int		bpp;
	int		line_len;
	int		endian;
}				t_image;

typedef struct s_point
{
	int		x;
	int		y;
	int		z;
}	t_point;

// 7x
int map[7][7] = {
    {1, 1, 1, 1, 1, 1, 1},
    {1, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 1},
    {1, 1, 1, 1, 1, 1, 1}
};

// dst => the address of the pixels in memory
// we adjust the offset of the with our x,y coords of the pixel along with the
// line_len and the bpp and just apply to that pixel the respective color
void	put_pixel_to_img(t_image img, int x, int y, int color)
{
	char	*dst;

	if (x >= 0 && y >= 0 && x < WIN_L && y < WIN_H)
	{
		dst = img.img_addr + (y * img.line_len + x * (img.bpp / 8));
		*(unsigned int *)dst = color;
	}
}

void	bresenham(t_image img, int x1, int y1, int x2, int y2)
{
	int	dx, sx, dy, sy, error, e2;

	dx = abs(x2 - x1);
	if (x1 < x2)
		sx = 1;
	else
		sx = -1;
	dy = -abs(y2 - y1);
	if (y1 < y2)
		sy = 1;
	else
		sy = -1;
	error = dx + dy;
	while (1)
	{
		put_pixel_to_img(img, x1, y1, 0xFF0000);
		if (x1 == x2 && y1 == y2)
			break ;
		e2 = 2 * error;
		if (e2 >= dy)
		{
			if (x1 == x2)
				break ;
			error = error + dy;
			x1 += sx;
		}
		if (e2 <= dx)
		{
			if (y1 == y2)
				break ;
			error = error + dx;
			y1 += sy;
		}
	}
}



int main()
{
	void 	*mlx_ptr;
	void 	*mlx_win;
	t_image	img;

	// iniciar coneccao mlx
	mlx_ptr = mlx_init();
	if (!mlx_ptr)
		return (-1); // error

	// iniciar janela
	mlx_win = mlx_new_window(mlx_ptr, WIN_L, WIN_H, "cub3d");
	if (!mlx_win)
	{
		free(mlx_ptr);
		return (-2);
	}

	// creating a new image
	img.img_ptr = mlx_new_image(mlx_ptr, WIN_L, WIN_H);
	if (!img.img_ptr)
	{
		free (mlx_win);
		free (mlx_ptr);
		return (-3);
	}
	img.img_addr = mlx_get_data_addr(img.img_ptr, &img.bpp, &img.line_len, &img.endian);


	// desenhar na imagem o mapa
	bresenham(img, 250, 250, 750, 250);
	bresenham(img, 250, 250, 250, 750);
	bresenham(img, 250, 750, 750, 750);
	bresenham(img, 750, 250, 750, 750);

	mlx_put_image_to_window(mlx_ptr, mlx_win, img.img_ptr, 0, 0);

	mlx_loop(mlx_ptr); // mantem a janela aberta
	return (0);
}
