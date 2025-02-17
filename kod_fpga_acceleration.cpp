#include<iostream>
#define MAX_ROWS 50
#define MAX_COL 50
using namespace std;

unsigned char maze[MAX_ROWS][MAX_COL]; 
int rows, cols;

void nacrtajLavirint(){
    unsigned int i = 0, j = 0;
    
    lredovi: if (i < rows) goto lkolone; else goto kraj;
    
    lkolone: if (j < cols) {
        if (maze[i][j] == 1) cout << "#";
        else cout << ".";
        j++;
        goto lkolone;
    } else {
        cout << "\n";
        i++;
        j = 0;
        goto lredovi;
    }
    
    kraj: return;
}

void generateMaze() {
    char stackX[MAX_ROWS * MAX_COL];
    char stackY[MAX_ROWS * MAX_COL];
    char stackTop = -1;
    
    char pravac[4][2] = {{0,1}, {0,-1}, {1,0}, {-1,0}};

    char i = 0, j = 0;
    char trenutnoX, trenutnoY, trenutniPravac;
    char novoX, novoY, slucajniPravac;
    char tempPravacX, tempPravacY; // Promenljive za privremeno čuvanje pravaca
    unsigned int lfsr = 0xACE1u; // Inicijalna vrednost LFSR-a
    unsigned int bit;

    lpocetak: if (i < rows) goto lspoljasnje; else goto ldalje;
    
    lspoljasnje: if (j < cols) {
        maze[i][j] = 1;
        j++;
        goto lspoljasnje;
    } else {
        i++;
        j = 0;
        goto lpocetak;
    }

    ldalje: 
    stackTop++;
    stackX[stackTop] = 0; // X koordinata
    stackY[stackTop] = 0; // Y koordinata
    maze[0][0] = 0;

    lstack: if (stackTop >= 0) goto lprocesiraj; else goto lend;
    
    lprocesiraj:
    trenutnoX = stackX[stackTop];
    trenutnoY = stackY[stackTop];
    stackTop--;

    trenutniPravac = 0;

    lmesanje: if (trenutniPravac < 4) {
        bit = ((lfsr >> 0) ^ (lfsr >> 2) ^ (lfsr >> 3) ^ (lfsr >> 5)) & 1;
        lfsr = (lfsr >> 1) | (bit << 15);
        slucajniPravac = lfsr % 4;

        
        tempPravacX = pravac[trenutniPravac][0];
        tempPravacY = pravac[trenutniPravac][1];

        pravac[trenutniPravac][0] = pravac[slucajniPravac][0];
        pravac[trenutniPravac][1] = pravac[slucajniPravac][1];

        pravac[slucajniPravac][0] = tempPravacX;
        pravac[slucajniPravac][1] = tempPravacY;

        trenutniPravac++;
        goto lmesanje;
    } else {
        goto ldalje1;
    }

    ldalje1:
    trenutniPravac = 0;

    lnovekoordinate: if (trenutniPravac < 4) {
        novoX = trenutnoX + 2 * pravac[trenutniPravac][0];
        novoY = trenutnoY + 2 * pravac[trenutniPravac][1];

        if (novoX >= 0 && novoX < rows && novoY >= 0 && novoY < cols && maze[novoX][novoY] == 1) {
            maze[novoX - pravac[trenutniPravac][0]][novoY - pravac[trenutniPravac][1]] = 0;//rusimio zid izmedju trenunte i nardne celije
            maze[novoX][novoY] = 0;//nova koordinata je sada deo laviritna

            stackTop++;
            stackX[stackTop] = novoX;
            stackY[stackTop] = novoY;
        }
        trenutniPravac++;
        goto lnovekoordinate;
    } else {
        goto lstack;
    }

    lend:
    nacrtajLavirint();
}


int main() {
    rows = 33;
    cols = 33;
    generateMaze();
    return 0;
}
