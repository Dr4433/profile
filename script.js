//---------------------------------------------------------
// Reset button - replayAnimations()
//---------------------------------------------------------

const replayAnimations = (play_again_flag) => {
  document.getAnimations().forEach((anim) => {
   anim.cancel();
   if (play_again_flag) {anim.play();}
  });
};

//---------------------------------------------------------
// Count down timer 
//---------------------------------------------------------
// Set the time duration we're counting down to 
let animation_delay = (1000 * (5/*sec*/));
let actual_timer = (1000 * (10/*sec*/) );
let correction = (1000 * (2/*sec*/));
let counDownTime = (new Date().getTime()) + animation_delay + actual_timer + correction;
let preCountDownTime = (new Date().getTime()) + animation_delay;
let preCountDownFlag = true;
// Update the count down every 1 second
let x = setInterval(function() {

  // Get today's date and time
  let now = new Date().getTime();
    
  // Find the distance between now and the count down date
  let distance = preCountDownFlag ? preCountDownTime - now : counDownTime - now;
    // console.log(preCountDownFlag)
    // console.log(distance)
    // console.log()
  // Time calculations for days, hours, minutes and seconds
  let minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
  let seconds = Math.floor((distance % (1000 * 60)) / 1000);
    
  // Output the result in an element with id="demo"
  document.getElementById("timer").innerHTML =  minutes + " : " + seconds + " ";
    
  // If the count down is over, write some text 
  if (distance < 0) {
    // console.log("first if check")
    if (preCountDownFlag) {
      preCountDownFlag = false;
      distance = counDownTime - now;
      // console.log("timer updated");
      document.getElementById("timer").innerHTML = "Starting Now";
    }
    else {
      clearInterval(x);
      document.getElementById("timer").innerHTML = "EXPIRED";
      alert("Time's up!!");
      replayAnimations(false)
      // console.log("time up")
    }
  }
}, 1000);
