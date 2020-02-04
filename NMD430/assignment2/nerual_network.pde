class Perceptrion{
   
  //multipe inputs 
  //each with a weight and a value
  //goes into a "neuron" which calculates values based on 
  // input1 weight * intput1 value + input2 weight.... 
  // outputs a value 
 
  Perceptrion(){}
 
  float weight(float[] values, float[] weights){
    float sum = 0;
    for(int i = 0; i < values.length; i++){
      sum += values[i] * weights[i];
    }
    
    return sum;
    
  }
 
  
}