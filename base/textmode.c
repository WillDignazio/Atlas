/* Text Mode Driver 
** Author: Will Dignazio 
** Description: 
**	Driver for text mode operations, on a 80x25 screen. The mode 
** and subsequently these functions, should only be used for 
** primitive setup. The next jump from this mode would be a VGA
** graphical environment.
*/

#include <textmode.h>

/* Load Buffer
** 	- Loads a text page buffer into video memory. 
** 	- Overwrites the memory written into video memory. 
** 	- Argument is the addres, or pointer, to the buffer to load 
*/
void t_load_buffer(unsigned char *page)
{ 
	unsigned char *vidmem = VIDMEM_START; 
	unsigned int i = 0; 
	while(i<sizeof(TEXT_PAGE_BUFFER)) { 
		vidmem[i] = page[i]; 
		i++; 
	} 
} 

/* Save Buffer
**	- Saves a text page buffer from video memory
** 	- Overwrite the page pointer given in the arguments 
**	- Argument is a pointer to the beginning of the page to save to 
*/
void t_save_buffer(unsigned char *page)
{ 
	unsigned char *vidmem = VIDMEM_START; 
	unsigned int i = 0; 
	while(i<sizeof(TEXT_PAGE_BUFFER)) { 
		page[i] = vidmem[i]; 
		i++;
	}
} 

/* Reset Buffer
** 	- Sets the column and row to 0
** 	- Effectively resetting the buffer. 
*/
void t_reset()
{ 
	TEXT_COLUMN = 0; 
	TEXT_ROW = 0; 
} 

void t_type(unsigned char ch)
{ 
	unsigned int i = TEXT_ROW*80*2;
	i += (2*TEXT_COLUMN); 
	VIDMEM_START[i] = ch;
	i++;
	VIDMEM_START[i] = GREY_TXT; 
	TEXT_COLUMN++;
};

/* Write Line Without Newline */
void t_write(unsigned char string[])
{
	unsigned int i = TEXT_ROW*80*2;
	i += (2*TEXT_COLUMN);
	char *message; 
	message = string; 
	while(*message != 0)
	{ 
		if (*message == '\n')
		{
			TEXT_ROW++; 
			i = (TEXT_ROW*80*2);
			*message++;
			TEXT_COLUMN = 0; 
		} else { 
			VIDMEM_START[i] = *message; 
			*message++;
			i++;
			VIDMEM_START[i] = GREY_TXT;
			i++;
			TEXT_COLUMN++; 
		};
	}; 
}; 

/* Print Line 
**	- Prints a line to the screen. 
**	- Line must end with the value 0
**	- Argument must be a character array.
*/
void t_writeln(unsigned char string[])
{
	unsigned int i = TEXT_ROW*80*2;
	i += (2*TEXT_COLUMN);
	char *message; 
	message = string; 
	while(*message != 0)
	{ 
		if (*message == '\n')
		{
			TEXT_ROW++; 
			i = (TEXT_ROW*80*2);
			*message++;
			TEXT_COLUMN = 0; 
		} else { 
			VIDMEM_START[i] = *message; 
			*message++;
			i++;
			VIDMEM_START[i] = GREY_TXT;
			i++;
			TEXT_COLUMN++; 
		};
	};
	TEXT_ROW++;
	TEXT_COLUMN=0;
};

/* Wipe Console
** 	- Wipes the console of all text.
**	- Technically fills it with spaces. 
*/
void t_wipe_console()
{
	char *vidmem = VIDMEM_START; 
	unsigned int i = 0; 
	while(i < (80*25*2))
	{
		vidmem[i] = ' ';
		i++;
		vidmem[i] = GREY_TXT;
		i++;
	};
};
