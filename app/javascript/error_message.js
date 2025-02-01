function flashMessageTimeOut() {
  const flashMessage = document.getElementById('flash-message');
  const replaceFlash = document.getElementById('replace-flash-message');
  if (flashMessage || replaceFlash) {
    let timeLeft = 4;

    const countdownInterval = setInterval(function () {
      timeLeft--;
      if (timeLeft <= 0) {
        clearInterval(countdownInterval);
        if (flashMessage){
          flashMessage.remove();
        };
        if (replaceFlash){
          replaceFlash.remove();
        };
      };
    }, 1000);
    if (flashMessage){
    flashMessage.addEventListener("click", function () {
      flashMessage.remove();
    })};
    if (replaceFlash){
    replaceFlash.addEventListener("click", function () {
      replaceFlash.remove();
    })};

  }
};
document.addEventListener("turbo:load", function(){
  flashMessageTimeOut();
});
document.addEventListener("click", function(){
  flashMessageTimeOut();
});

