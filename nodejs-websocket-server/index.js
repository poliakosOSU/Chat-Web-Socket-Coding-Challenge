const WebSocket = require('ws');
const uuid = require('uuid');

const wss = new WebSocket.Server({ port: 8080 });

var connected_users = {};


function isJSON (something) {
    if (typeof something != 'string')
        something = JSON.stringify(something);

    try {
        JSON.parse(something);
        return true;
    } catch (e) {
        return false;
    }
}


// Possibly include client authentication

wss.on('connection', function connection(ws, request) {

  ws.client_id = uuid.v4();
  ws.send('Your client Id:' + ws.client_id)


  ws.on('message', function incoming(message) {
    console.log('Received: %s', message);

    if(isJSON(message) == true){
      var obj = JSON.parse(message)
      console.log("The Name Is: " + obj.name)
      console.log("The Message Is: " + obj.message)

      wss.clients.forEach(function each(client){
        //if(client !== ws && client.readyState === WebSocket.OPEN){
        if(client.readyState === WebSocket.OPEN){
          client.send(message)
        }
      })

      //ws.send("Message" + message)
    }



    // if(message != "<anonymous>"){
    //   var obj = JSON.parse(message)
    // }

    //console.log("The Name Is: " + obj.name)
    //console.log("The Message Is: " + obj.message)



  })


  ws.on('close', function(){
    console.log('client droped:', ws.client_id)
  });

});
