Literal[NonCommutativeMultiply[front___,i,i,back___]] := 
          -NonCommutativeMultiply[front,back];
Literal[NonCommutativeMultiply[front___,j,j,back___]] := 
          -NonCommutativeMultiply[front,back];
Literal[NonCommutativeMultiply[front___,k,k,back___]] := 
          -NonCommutativeMultiply[front,back];
Literal[NonCommutativeMultiply[front___,i,j,back___]] :=  
           NonCommutativeMultiply[front,k,back];
Literal[NonCommutativeMultiply[front___,j,i,back___]] := 
          -NonCommutativeMultiply[front,k,back];
Literal[NonCommutativeMultiply[front___,i,k,back___]] := 
          -NonCommutativeMultiply[front,j,back];
Literal[NonCommutativeMultiply[front___,k,i,back___]] :=  
           NonCommutativeMultiply[front,j,back];
Literal[NonCommutativeMultiply[front___,j,k,back___]] :=  
           NonCommutativeMultiply[front,i,back];
Literal[NonCommutativeMultiply[front___,k,j,back___]] := 
          -NonCommutativeMultiply[front,i,back];
