// フレームの編集リンクを表示
document.addEventListener("turbo:load", function () {
  const frameContainers = document.querySelectorAll("[id^='frame-container-']");

  frameContainers.forEach(container => {
    const frameNumber = container.id.replace("frame-container-", "");// フレーム番号を取得（idから抽出）
    const editTools = document.getElementById(`edit-tools-${frameNumber}`);
    container.addEventListener("click", (e) => {
      if (editTools) {
        editTools.style.display = "block";
        e.stopPropagation();
      }
    });
    document.addEventListener("click", () => {
      if (editTools) {
        editTools.style.display = "none";
      }
    });
  });
});

// チュートリアルに切り替え
document.addEventListener("turbo:load", function () {
  const mainContainer = document.getElementById("main-container");
  const tutorialContainer = document.getElementById("tutorial-container");
  const tutorialButton = document.getElementById("tutorial-button");

  if (mainContainer && tutorialContainer && tutorialButton) {
    tutorialButton.removeEventListener("click", toggleContainers);
    tutorialButton.addEventListener("click", toggleContainers);
  }
});
function toggleContainers(e) {
  e.stopPropagation();
  const mainContainer = document.getElementById("main-container");
  const tutorialContainer = document.getElementById("tutorial-container");

  if (mainContainer.style.display === "none") {
    mainContainer.style.display = "block";
    tutorialContainer.style.display = "none";
  } else {
    mainContainer.style.display = "none";
    tutorialContainer.style.display = "block";
  }
}
