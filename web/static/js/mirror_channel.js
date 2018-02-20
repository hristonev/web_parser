let MirrorChannel = {
    init(mirror, socket){
        socket.connect();
        this.onReady(mirror, socket);
    },
    onReady(mirror, socket){
        let userChannel = socket.channel("mirror_channel:" + mirror.id);

        if(mirror.start){
            mirror.start.addEventListener("click", e => {
                let payload = {
                    cmd: 'start',
                    mirror: mirror.id
                };
                userChannel.push("cmd", payload)
                    .receive("error", e => console.log(e) )

            });
        }

        if(mirror.pause){
            mirror.pause.addEventListener("click", e => {
                let payload = {
                    cmd: 'pause',
                    mirror: mirror.id
                };
                userChannel.push("cmd", payload)
                    .receive("error", e => console.log(e) )

            });
        }

        if(mirror.stop){
            mirror.stop.addEventListener("click", e => {
                let payload = {
                    cmd: 'stop',
                    mirror: mirror.id
                };
                userChannel.push("cmd", payload)
                    .receive("error", e => console.log(e) )

            });
        }

        userChannel.join()
            .receive("ok", resp => console.log("joined the mirror channel", resp) )
            .receive("error", reason => console.log("join mirror failed", reason) )

        userChannel.on("message", (resp) => {
            let badge = document.createElement('span');
            badge.setAttribute('class', 'badge');
            badge.append(resp.type);

            let element = document.getElementById(resp.txt);
            if(element){
                console.log("opa");
                element.appendChild(badge);
            }else{
                let container = document.getElementsByTagName("main")[0];
                element = document.createElement('div');
                element.setAttribute('class', 'list-group-item');
                element.setAttribute('id', resp.txt);
                element.append(resp.txt);
                element.append(badge);
                container.append(element);
            }
            window.scrollTo(0, element.offsetTop);
        })

    }
};
export default MirrorChannel