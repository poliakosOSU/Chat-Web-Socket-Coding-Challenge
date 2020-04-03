const WebSocket = require('ws');
const uuid = require('uuid');

const wss = new WebSocket.Server({ port: 8080 });

connected_users_w_id = {}
connected_users = {}
removedIndeces = []
numUsers = 0

// put stack overflow link
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

// change name of method
function getUser(id){
    var name
    ctUsrsLenth = countProperties(connected_users_w_id)
    console.log(ctUsrsLenth)
    for(var i = 0; i < numUsers; i++){
      if(removedIndeces.includes(i) === false){
        console.log("the UUID " + connected_users_w_id[i].UUID)
        if(id === connected_users_w_id[i].UUID){
          name = connected_users_w_id[i].name
          delete connected_users_w_id[i]
          delete connected_users[i]
          removedIndeces.push(i)
          //numUsers--
          break

      }
    }
    }

    if(ctUsrsLenth === 1){
      numUsers = 0
      removedIndeces = []

    }
    console.log("Num Users " + numUsers)
    return name
}

//https://stackoverflow.com/questions/956719/number-of-elements-in-a-javascript-object
function countProperties(obj) {
    return Object.keys(obj).length;
}

// function removeA(arr) {
//     var what, a = arguments, L = a.length, ax;
//     while (L > 1 && arr.length) {
//         what = a[--L];
//         while ((ax= arr.indexOf(what)) !== -1) {
//             arr.splice(ax, 1);
//         }
//     }
//     return arr;
// }


// Possibly include client authentication

wss.on('connection', function connection(ws, request) {

  ws.client_id = uuid.v4();

  ws.send('Your client Id:' + ws.client_id)

  ws.on('message', function incoming(message) {
    console.log('Received: %s', message);



    if(isJSON(message) === true){
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
    } else{
      //flip statement around later Possibly
      var pos = message.indexOf(" ")
      var clientName = message.substring(0, pos)

      var userWid = {name: clientName, UUID: ws.client_id} // user with UUID
      connected_users_w_id[numUsers] = userWid

      connected_users[numUsers] = clientName

      //connected_users_w_id.push(userWid) // store user with correspding UUID to current connected_users_w_id list
      //console.log(connected_users_w_id)

      //connected_users.push(clientName)

      //var connectData = {dataType: "usrConnect", message: "NULL", name: clientName, UUID: ws.client_id}





      var makeConnections = {
        dataType: "makeConnections",
        message: "NULL",
        name: clientName,
        UUID: ws.client_id,
        connectedUsers: connected_users
      }

      var addUsr = {
        dataType: "addUsr",
        message: "NULL",
        name: clientName,
        UUID: ws.client_id,
        connectedUsers: {}
      }

      console.log("Accessed")

      wss.clients.forEach(function each(client){
        //send to all but self
        if(client === ws && client.readyState === WebSocket.OPEN){
          client.send(JSON.stringify(makeConnections))
        }

        if(client !== ws && client.readyState === WebSocket.OPEN){
          client.send(JSON.stringify(addUsr))
        }
      })


      // console.log(JSON.stringify(connectData))
        console.log(makeConnections)

        numUsers++
    }


  })


  ws.on('close', function(){
    console.log('client droped:', ws.client_id)

    // possibly use a Map

    //get username of user which disconnected
    // change name of method
    var userName = getUser(ws.client_id)

    console.log("userName: " + userName)
    console.log("numUsers: " + numUsers)
    console.log("connected_users")
    console.log(connected_users)
    console.log("connected_users_w_id")
    console.log(connected_users_w_id)



    var disconnectData = {dataType: "usrDisconnect",
                          message: "NULL",
                          name: userName,
                          UUID: ws.client_id,
                          connectedUsers: []
                        }

    console.log(disconnectData)
    wss.clients.forEach(function each(client){
      //send to all but self
      if(client !== ws && client.readyState === WebSocket.OPEN){
        client.send(JSON.stringify(disconnectData))
      }
    })

  });

});
