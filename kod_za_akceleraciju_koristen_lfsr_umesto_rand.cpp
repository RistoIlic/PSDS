#include<iostream>
#define MAX_ROWS 50
#define MAX_COL 50
using namespace std;

unsigned char maze[MAX_ROWS][MAX_COL]; 
int rows, cols;

unsigned int lfsr = 0xACE1u; // Inicijalna vrednost LFSR-a
unsigned int bit;

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
    int stack[MAX_ROWS * MAX_COL][2];
    int stackTop = -1;
    
    int pravac[4][2] = {{0,1}, {0,-1}, {1,0}, {-1,0}};

    // Premestena deklaracija promenljivih na pocetak
    int i = 0, j = 0;
    int trenutnoX, trenutnoY, trenutniPravac;
    int novoX, novoY, slucajniPravac;
    int zamenaPravca[2];
    
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
    stack[stackTop][0] = 0;
    stack[stackTop][1] = 0;
    maze[0][0] = 0;

    lstack: if (stackTop >= 0) goto lprocesiraj; else goto lend;
    
    lprocesiraj:
    trenutnoX = stack[stackTop][0];
    trenutnoY = stack[stackTop][1];
    stackTop--;

    trenutniPravac = 0;

    lmesanje: if (trenutniPravac < 4) {
        // Generisanje slučajnog pravca pomoću LFSR-a
        bit = ((lfsr >> 0) ^ (lfsr >> 2) ^ (lfsr >> 3) ^ (lfsr >> 5)) & 1;
        lfsr = (lfsr >> 1) | (bit << 15);
        slucajniPravac = lfsr % 4;

        // Zamena pravaca
        zamenaPravca[0]= pravac[trenutniPravac][0];
        zamenaPravca[1] = pravac[trenutniPravac][1];

        pravac[trenutniPravac][0] = pravac[slucajniPravac][0];
        pravac[trenutniPravac][1] = pravac[slucajniPravac][1];

        pravac[slucajniPravac][0] =  zamenaPravca[0];
        pravac[slucajniPravac][1] = zamenaPravca[1];

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
            maze[novoX - pravac[trenutniPravac][0]][novoY - pravac[trenutniPravac][1]] = 0;
            maze[novoX][novoY] = 0;

            stackTop++;
            stack[stackTop][0] = novoX;
            stack[stackTop][1] = novoY;
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
    rows = 25;
    cols = 25;
    generateMaze();
    return 0;
}

