#include<iostream>
#include <ctime>
#include <cstdlib>
#include<cmath>
#define MAX_ROWS 50//max redova lavirinta
#define MAX_COL 50//masx kolona lavirinta  
using namespace std;

 unsigned char maze[MAX_ROWS][MAX_COL];//laviritn
    int rows;        // Broj redova lavirinta
    int cols;        // Broj kolona lavirinta


void nacrtajLavirint(){
     for(unsigned int i=0;i<rows;i++){
    for(unsigned int j=0;j<cols;j++){
     
     if(maze[i][j]==1){
       cout<<"#";//zid
     }else{
          cout<<".";//putanja
     }
    }
     cout<<"\n";

}


}


void generateMaze() {
           //int maze[MAX_ROWS][MAX_COL];//lavirint
           cout<<"HARD GENERISE LAVIRITN"<<endl;
    int stack[rows*cols][2];//stek za cuvanje kordinata dfs 
     int stackTop=-1;//"pokazivac" na vrh steka.Posto nas stek radi na principu FIFO stackTop ce mi pokazivati na prvi upisani/obrisani elemnt sa steka
     
     int pravac[4][2]={//pravci kretanja kroz matricu,tj lavirint
     {0,1},//desno
     {0,-1},//levo
     {1,0},//dole
     {-1,0}//gore
     };
   
   int trenutniPravac,slucajniPravac,zamenaPravca[2];
   int novoX,novoY,trenutnoX,trenutnoY;//trenutne i nove pozicije koordinara u lavirintu

   //inicijlazicacija lavirnta da su sve zidovi
      /*for(unsigned int i=0;i<rows;i++){
      for(unsigned int j=0;j<cols;j++){
         maze[i][j]=1;//matrica zidova
      }
      }*/
      //************************************************************************
      //zamene sa if-goto
           
         
          unsigned int i=0,j=0;
        
        lpocetak:if(i<rows){
            goto lspoljasnje;
        }else{
            goto ldalje;
        }
        
        lspoljasnje:if(j<cols){
              maze[i][j]=1;
              j++;
              goto lspoljasnje;
        }else{
              i++;
              j=0;
              goto lpocetak;
              
        }

         //kraj zamene sa if-goto
         //*************************************************************************
        ldalje: stackTop++;//ubaci na stek
         stack[stackTop][0]=0;//X kordinata  //}
                                             //na stek stmo stavili pocetnu poziciju (0,0) kao pocetak lavirint(startna tacka)
         stack[stackTop][1]=0;//Y kordianra  //}
       
       maze[0][0]=0;//pocetna pozicija,gde 0 predstvalja put
       
       srand(time(0));
    
    //zamen sa if-goto
   /* while(stackTop>=0){

       trenutnoX=stack[stackTop][0]; //sa steka smo uzeli vrednosti,i sada to postaju kordinate,koje predstavljaju pravac kretanaj dfs-a X osa
       trenutnoY=stack[stackTop][1]; // -||- Y osa
       stackTop--;//skini sa steka
       
       //mesanje pravaca,da bi dobili razlicite lavirinte
         for(trenutniPravac=0;trenutniPravac<4;trenutniPravac++){
              slucajniPravac=rand()%4;//ovde smo smestili neki od pravaca u kome ce krenuti laviritn
              
              zamenaPravca[0]=pravac[trenutniPravac][0];//cuva privremene vrednosti trenutnog tavca po X osi(slucajna pozicija X)
              zamenaPravca[1]=pravac[trenutniPravac][1];//po Y osi(slucajna pozicija Y)
              
             pravac[trenutniPravac][0]=pravac[slucajniPravac][0]; 
             pravac[trenutniPravac][1]=pravac[slucajniPravac][1];    
         
            pravac[slucajniPravac][0]=zamenaPravca[0];
            pravac[slucajniPravac][1]=zamenaPravca[1];
         }
         
         //trazenje novih koordinta,odakle ce dfs nastaviti sa radom
         for(trenutniPravac=0;trenutniPravac<4;trenutniPravac++){
            novoX=trenutnoX+2*pravac[trenutniPravac][0];//ovde smo mnozenjem sa 2 omogucili da imamo zid izmedju dve susedne celij
            novoY=trenutnoY+2*pravac[trenutniPravac][1];
          //proveravamo da li su nove kordiante u ospsegu,i da li je celija sa novim koridantama jos uvek zid
           if(novoX>=0 && novoX<rows && novoY>=0 && novoY<cols && maze[novoX][novoY]==1){
           
           maze[novoX-pravac[trenutniPravac][0]][novoY-pravac[trenutniPravac][1]]=0;//kordinate celije koja se nalazi tacno izmejdu trenutne i sledece celije
           maze[novoX][novoY]=0;//prolaz
           
           
             stackTop++;//dodajemo novu poziciju na stek
             stack[stackTop][0]=novoX;//na stek su dodate nove pozicije po X osi
             stack[stackTop][1]=novoY;//-||- po Y osi
           
           }
            
            
         }
}*/

           lstack:if(stackTop>=0){
       	trenutnoX=stack[stackTop][0]; //sa steka smo uzeli vrednosti,i sada to postaju kordinate,koje predstavljaju pravac kretanaj dfs-a X osa
       	trenutnoY=stack[stackTop][1]; // -||- Y osa
       	stackTop--;//skini sa steka
                
                trenutniPravac=0;
                
                lmesanje:if(trenutniPravac<4){ //mesanje pravaca,da bi dobili razlicite lavirinte
                     slucajniPravac=rand()%4;//ovde smo smestili neki od pravaca u kome ce krenuti laviritn
              
              	      zamenaPravca[0]=pravac[trenutniPravac][0];//cuva privremene vrednosti trenutnog tavca po X osi(slucajna pozicija X)
                     zamenaPravca[1]=pravac[trenutniPravac][1];//po Y osi(slucajna pozicija Y)
              
                      pravac[trenutniPravac][0]=pravac[slucajniPravac][0]; 
                      pravac[trenutniPravac][1]=pravac[slucajniPravac][1];    
         
                      pravac[slucajniPravac][0]=zamenaPravca[0];
                      pravac[slucajniPravac][1]=zamenaPravca[1];
                         
                      trenutniPravac++;
                      goto lmesanje;
                }else{
                        goto ldalje1;
                    
                 }

               ldalje1:trenutniPravac=0;
                      lnovekoordinate:if(trenutniPravac<4){ //trazenje novih koordinta,odakle ce dfs nastaviti sa radom
                      novoX=trenutnoX+2*pravac[trenutniPravac][0];//ovde smo mnozenjem sa 2 omogucili da imamo zid izmedju dve susedne celij
                      novoY=trenutnoY+2*pravac[trenutniPravac][1];
                                                                  //proveravamo da li su nove kordiante u ospsegu,i da li je celija sa novim koridantama jos uvek zid
                                       if(novoX>=0 && novoX<rows && novoY>=0 && novoY<cols && maze[novoX][novoY]==1){
           
                                      maze[novoX-pravac[trenutniPravac][0]][novoY-pravac[trenutniPravac][1]]=0;//kordinate celije koja se nalazi tacno izmejdu trenutne i sledece celije
                                      maze[novoX][novoY]=0;//prolaz
           
           
             				stackTop++;//dodajemo novu poziciju na stek
             				stack[stackTop][0]=novoX;//na stek su dodate nove pozicije po X osi
             				stack[stackTop][1]=novoY;//-||- po Y osi
                      }
                            trenutniPravac++;
                            goto lnovekoordinate;
               }else{
                        goto ldalje3;
               }
               
               ldalje3:

              goto lstack;
               }else{
                 
                  goto lend;
               }
          
           //cout<<"CRTANJE"<<endl;
           lend:     nacrtajLavirint();
            
            cout<<"IZGENERSIAN LAVIRITN"<<endl;
                      
 }





int main(){
       rows=15;
       cols=15;
       generateMaze();
      
    
   return 0;  

}
