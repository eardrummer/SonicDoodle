OscP5 oscP5_pd;


// a NetAddress contains the ip address and port number of a remote location in the network.
NetAddress myRemoteLocation_pd; 

void OSCPDsetup() {
  // create a new instance of oscP5_pd. 
  // 12000 is the port number you are listening for incoming osc messages.
  oscP5_pd = new OscP5(this,12000);
  
  // create a new NetAddress. a NetAddress is used when sending osc messages
  // with the oscP5_pd.send method.
  myRemoteLocation = new NetAddress("127.0.0.1",12001);
}

void sendNote(float pitch, float vibrato, float vibratoLevel, int[] instrument){
  OscMessage myOscMessage = new OscMessage("/sound");
  myOscMessage.add(pitch);
  myOscMessage.add(vibrato);
  myOscMessage.add(vibratoLevel);
  myOscMessage.add(instrument[0]);
  myOscMessage.add(instrument[1]);
  myOscMessage.add(instrument[2]);
  // send the OscMessage to a remote location specified in myNetAddress
  oscP5_pd.send(myOscMessage, myRemoteLocation);
}

void OSCPDdraw(int pitch, float vibrato, int instrum){
    //float pitch = random(100,500);
    //float ins = random(0,1);
    int[] instrument = {0,0,0};
    //if (ins < 0.3){
    //  instrument[0] = 1;
    //}else {
    //  if(ins < 0.6){
    //    instrument[1] = 1;
    //  }else{
    //    instrument[2] = 1;
    //  }
    //}
    if (instrum == 1){
      instrument[1] = 1;
    }else{
      instrument[1] = 0;
    }
    
    float vibratoLevel = (1 - vibrato) * 100;
    
    if (vibratoLevel > 70){
      
      vibrato = 1;    
    }
    else {
      
      vibrato = 0;
    
    }
       
    sendNote(pitch, vibrato, vibratoLevel, instrument);
}