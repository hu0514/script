function toPages(){
    var initClick = document.createEvent("MouseEvents");
      initClick.initEvent("click", true, true)
      document.querySelector(".NavIcon--1wBvpinAHknVabtHQjm4ln.NavIcon-cal--1Zy4yjU_fgR468ySl6lUgk").dispatchEvent(initClick)
     console.log(1)
     setTimeout(()=> {toPages()},2000)
}
to_Pages()