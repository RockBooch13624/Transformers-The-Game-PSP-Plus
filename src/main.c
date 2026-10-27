/*
 * Transformers: The Game (PSP) - PC port entry point.
 *
 * Placeholder until decompiled game code is added. For now it confirms
 * that the build pipeline works and that the extracted game data is found.
 */
#include <stdio.h>

#define BOOT_PATH "game_data/PSP_GAME/SYSDIR/BOOT.BIN"

int main(void)
{
    FILE *f = fopen(BOOT_PATH, "rb");
    if (!f) f = fopen("../" BOOT_PATH, "rb");  /* when run from bin\ */
    if (!f) {
        printf("Game data not found. Run build.bat and select your ISO first.\n");
        getchar();
        return 1;
    }

    fseek(f, 0, SEEK_END);
    long size = ftell(f);
    fclose(f);

    printf("Transformers PC port\n");
    printf("Game data found (BOOT.BIN, %ld bytes).\n", size);
    printf("Decompilation in progress - the game itself is not playable yet.\n");
    getchar();
    return 0;
}
