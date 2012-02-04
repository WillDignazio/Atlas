/* Standard Input and Output Header 
** Author: Will Dignazio
** Description: 
** 		Provides standard functions for printing text to the screen, and 
** 	taking input from the user. 
*/
#ifndef STDIO_H_GAURD_ 
#define STDIO_H_GAURD_

#define WHITE_TXT	0x07
#define BLUE_TXT	0x1F
#define GREY_TXT	0x70
#define PURPLE_TXT	0x50
#define GREEN_TXT	0x2A

#define VIDMEM_START ((unsigned char *) 0xB8000)
#define VIDMEM_END ((unsigned char *) 	(VIDMEM_START+4000)

static unsigned int TEXT_ROW=0; 
static unsigned int TEXT_COLUMN=0; 

typedef struct TEXT_CHAR_BUFFER { unsigned short BUFFER[1]; } TEXT_CHAR_BUFFER; 
typedef struct TEXT_LINE_BUFFER { TEXT_CHAR_BUFFER BUFFER[80]; } TEXT_LINE_BUFFER; 
typedef struct TEXT_PAGE_BUFFER { TEXT_LINE_BUFFER BUFFER[25]; } TEXT_PAGE_BUFFER; 

/* Text Mode Operations */
void t_wipe_console();							// Wipe Console
void t_writeln(unsigned char string[]); 			// Print text
void t_write(unsigned char string[]); 					// Print character
void t_type(unsigned char ch); 
void t_reset(); 
void t_load_buffer(unsigned char *page); 
void t_save_buffer(unsigned char *page); 

#endif
