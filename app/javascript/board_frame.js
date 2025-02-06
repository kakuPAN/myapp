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
