import { UI_Header } from './UI.UI_Header.mjs';
import { UI_Footer } from './UI.UI_Footer.mjs';

const main = {};

window.startUI = function(worker, el) {
    main.Header = UI_Header.init({node: el.header});
    main.Footer = UI_Footer.init({node: el.footer});
    main.element = el;
    main.Worker = worker;

    main.Worker.postMessage(['start', { url: window.location.hash }]);
    main.Worker.addEventListener('message', handleWorkerMessage.bind(main));

    window.addEventListener('hashchange', (event) => {
        const newURL = new URL(event.newURL);
        window.scrollTo(0, 0);
        main.Worker.postMessage(['recv_UrlChange', newURL.hash]);
    });
}

function handleWorkerMessage(event) {
    const to = event.data.to;
    const msg = event.data.msg;

    if (to.match(/Page_/)) {
        startPageApp(to, main.element.main, msg);
        return;
    }

    const receiver = this[to];

    if (!receiver) {
        console.log('No receiver: ', to, msg);
        return;
    }

    const portName = `recv_${to}`;

    if (!receiver.ports) {
        console.log('Receiver has no ports: ', to, msg);
        return;
    }

    const port = receiver.ports[portName];

    if (!port || !port.send) {
        console.log('No receiver port', to, portName, msg);
        return;
    }

    port.send(msg);
}


function startPageApp(name, element, flags) {
    const appName = 'UI_' + name;
    element.innerHTML = `<pre>Loading ${appName}...</pre>`;
    element.className = 'constrained fade-in spinner';
    delete main.page;
    return import(`./UI.${appName}.mjs`)
        .then(Elm => {
            main.page = Elm[appName].init({
                node: element,
                flags: { data : flags }
            });
        });

}
