function setup(){
  noCanvas();

  var bot = new RiveScript();
  bot.loadFile("brain.rive", ready, error);

  function ready(){
    console.log("bot is online");
  }

  function error(){
    console.log("bot is offline :(");
  }




}


function draw(){

}
