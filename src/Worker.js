
const { Elm } = require('./Worker.elm.js');

addEventListener('message', startWorker);

function startWorker(event) {
    let tag = event.data[0];
    let flags = event.data[1];

    if (tag !== 'start') {
        console.log('NOT START', flags);
        return;
    }

    const app = Elm.Worker.init({ flags: flags });
    removeEventListener('message', startWorker);
    addEventListener('message', receiveMessage.bind(app));
    attachOutgoingPorts(app);
}

function receiveMessage(event) {
    const portName = event.data[0];
    const msg = event.data[1];

    const port = this.ports[portName];

    if (!port || !port.send) {
        console.log('No worker port', portName, msg);
    }

    port.send(msg);
}

function attachOutgoingPorts(app) {
    for (let name in app.ports) {
        let port = app.ports[name];

        if (!port.subscribe) {
            continue;
        }

        port.subscribe(function(msg) {
            let receiver = name.replace(/^sendTo_/, '');
            postMessage({ to: receiver, msg: msg } );
        });
    }
}

