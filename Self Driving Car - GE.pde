int TotalCar = 10, DNAsequence = 1500, generation = 0, stepSize = 20, aliveColoumn = 0, BestCarDNAindex = 0, BestCar = 0, simulationSpeed = 60;
float fitness = 0.0;
int[][] CarDNA;
int[] PerGenerationDNAindex = new int[10];
int[] IdealDNA = new int[DNAsequence];

int move;
int carX = 125,carY = 125;
float rand,collision;


int Universal_i = 0, Universal_j = 0;



void setup() 
{
  
  size(1200, 650);
  noStroke();
  frameRate(simulationSpeed);
  CarDNA = new int[TotalCar][DNAsequence];
  
  int i,j;
                                        
       for(j = 0; j < DNAsequence; j++){                              // initializing IdealDNA cells
            if( j <= 500)
            IdealDNA[j] = 1;
            else if(j > 500 && j <= 900)
            IdealDNA[j] = 3;
            else
            IdealDNA[j] = 1;
       }
 
  
  for(i = 0; i < TotalCar; i++){                                          // initializing initialCarDNA cells
       for(j = 0; j < DNAsequence; j++){
           
                 if(j == 0)
                     CarDNA[i][j] = 0;                                      // making car alive with every [i,0] = 0; for dead -1 
                 else{
                     rand = random(1,4);
                     if(rand >= 1 && rand < 2 )
                     CarDNA[i][j] = 1;
                     else if(rand >= 2 && rand < 3 )
                     CarDNA[i][j] = 2;
                     else if(rand >= 3 && rand < 4 )
                     CarDNA[i][j] = 3;
                     }
       }
   }
  textSize(15);
  smooth();
}




void draw() 
{
  background(102);
  
  fill(200);                                            // track
  rect(100,100,600,100);
  rect(600,200,100,400);
  rect(600,500,500,100);
  
  text("COLLISION      : ",980,150);
  fill(0,255,0);
  ellipse(1160,150,30,30);
  
  fill(200); 
  text("Generation     : ",980,20);
  text(generation,1150,20);
  text("Car On Display : ",980,40);   
  text(Universal_i+1,1150,40);
  text("Step Size : ",980,60);
  text(stepSize,1150,60);
  text("Fittest Car : ",980,80);
  text(BestCar,1150,80);
  text("Fittest Car DNA index : ",980,100);
  text(BestCarDNAindex,1150,100);
  text("Fitness Value : ",980,120);
  text(fitness,1140,120);
                 
  
  
  //rect(125,125,25,25);                      // car
  
  move = ReadFromMatrix();
  
 fill(0);
 if(move == 1){                                  // move right
      rect(carX,carY,25,25); 
      carX +=stepSize;
 }
 if(move == 2){                                  // move up
      rect(carX,carY,25,25); 
      carY -= stepSize ;
 }
 if(move == 3){                                  // move down
      rect(carX,carY,25,25); 
      carY += stepSize;
 }
 
 
 isCollision();
}

//---------------------------------------------------------------------------------------------------------------------//

int ReadFromMatrix(){
    
  int RedMove = 0;
  
        Universal_j++; 
        PerGenerationDNAindex[Universal_i] = Universal_j; 
        RedMove = CarDNA[Universal_i][Universal_j];
        if(Universal_j == DNAsequence - 1)
            Universal_j = 0;
  return RedMove;
 }

//---------------------------------------------------------------------------------------------------------------------//

void isCollision(){
  int collision = 0;
  if(  carY <= 100 || carX + 25 >= 700 || carY + 25 >= 200 ){                              // if collision on path 1
            collision = 1;  
            if(  carX > 600 && carX + 25 <= 700 && carY + 25 >= 200)                       // exception in path gatway 1-2     
            collision = 0; 
       
  }
  if(  carY + 25 >= 500 ){                              // if collision on path 3
            collision = 1;
            if(  carX > 600 && carX + 25 <= 1100 && carY + 25 <= 600 )                       // exception in path gatway 2-3     
            collision = 0;
            if( carX + 25 >= 700 && carY <= 500)
            collision =1;
  }
        
  if(collision == 1){
         fill(255,0,0);
         ellipse(1160,150,30,30);
         println("Collision of car = "+Universal_i+" at GeneDNAindex = "+Universal_j);
         CarDNA[Universal_i][aliveColoumn] = -1;                                    // killing the car
         Universal_i++;
         Universal_j = 0;
         carX = 125; 
         carY = 125;
         if(Universal_i == TotalCar)
            Selection();
         }     
}

//---------------------------------------------------------------------------------------------------------------------//

void Mutation(){  //  mutation
  if(CarDNA[BestCar][BestCarDNAindex] == 2)
    CarDNA[BestCar][BestCarDNAindex] = 3;
  else if(CarDNA[BestCar][BestCarDNAindex] == 1)  
    CarDNA[BestCar][BestCarDNAindex] = 3; 
  else
    CarDNA[BestCar][BestCarDNAindex] = 1;
}

//---------------------------------------------------------------------------------------------------------------------//
void Selection(){                    // selection
    
    int i,j,sum = 0;
    int [] bunch = new int[DNAsequence];
    for(j = 0; j < TotalCar ; j++){                                                        // finding best CAR
          if(PerGenerationDNAindex[j] >= BestCarDNAindex){
              BestCarDNAindex = PerGenerationDNAindex[j];
              BestCar = j;
          }  
    }
    println(" ");
    println(">>BestCar = "+BestCar+" BestCarDNAindex = "+BestCarDNAindex);
    println(" ");

    for(i = 0; i <= BestCarDNAindex; i++){
      bunch[i] = 0;  
      bunch[i] = CarDNA[BestCar][i] - IdealDNA[i]; 
    }  
    for(i = 0; i <= BestCarDNAindex; i++){
        sum = sum + bunch[i];
    }
    fitness = (float)sum / BestCarDNAindex;
    
    Mutation();
    Reproduction();      
          

}
//--------------------------------------------------------------------------------------------------------------------------//
void Reproduction(){
    int i,j;
    generation++;
    Universal_i = Universal_j = 0;
    for(i = 0; i < TotalCar; i++)                                                          // making all car alive
          CarDNA[i][aliveColoumn] = 0;
          
    for(i = 0; i < TotalCar; i++)
    for(j = 0; j <= BestCarDNAindex; j++){
          CarDNA[i][j] = CarDNA[BestCar][j];
    }


}