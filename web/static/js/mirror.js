class Mirror {
    constructor(element){ if(!element && typeof element !== "object"){ return }
        this.id = element.getAttribute("data-id");
        this.element = element;
        this.start = this.getNodeByClassName('js-start');
        this.pause = this.getNodeByClassName('js-pause');
        this.stop = this.getNodeByClassName('js-stop');
    }

    getNodeByClassName(className) {
        let nodeCollection = this.element.getElementsByClassName(className);
        if(nodeCollection.length > 0){
            return nodeCollection[0];
        }else{
            return null;
        }
    }

    static fetch_all() {
        let nodeCollection = document.getElementsByClassName('js-mirror');
        let dataCollection = [];
        for(let node of nodeCollection){
            dataCollection[dataCollection.length] = new Mirror(node);
        }
        // console.log(nodeCollection);
        // let dataCollection = [];
        // for(let i = 0){
        //     dataCollection[i] = new Mirror(nodeCollection[i]);
        // }
        return dataCollection;
    }
}

export default Mirror