//the serial communication does not use the draw loop be default. 
void serialEvent(Serial myPort) {
//put the incoming data into a String - 
//the '\n' is our end delimiter indicating the end of a complete packet
val = myPort.readStringUntil('\n');

//make sure our data isn't empty before continuing
if (val != null) {
 
  //trim whitespace and formatting characters (like carriage return)
  val = trim(val);
  //println(val);

  //look for our 'A' string to start the handshake
  //if it's there, clear the buffer, and send a request for data
  if (firstContact == false) {
    if (val.equals("A")) {
      myPort.clear();
      firstContact = true;
      myPort.write("A");
      //println("contact from processing");
    }
  }
  else { 
    //if we've already established contact, keep getting and parsing data
    //println(val);
    
    println("comfirmed ", val);

    //for communication back to the arduino only when mouse is clicked
    //tell aruino '1'
    //if (mousePressed == true) 
    //{                           
    //  myPort.write('1');        
    //  println("1");
    //}

    // when you've parsed the data you have, ask for more:
   ///myPort.write("A");
    }
  }
}