<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>日文學習播放器</title>
    <style>
        body { font-family: sans-serif; padding: 20px; line-height: 1.8; }
        .active { color: #ff4500; font-weight: bold; background-color: #fff0f0; }
        .sentence { cursor: pointer; padding: 5px; border-radius: 4px; display: block; }
        #player-container { position: sticky; top: 0; background: white; padding: 10px 0; border-bottom: 1px solid #ddd; }
    </style>
</head>
<body>

<div id="player-container">
    <audio id="audioPlayer" controls src="lesson.mp3"></audio>
</div>

<div id="content">讀取中...</div>

<script>
    const audio = document.getElementById('audioPlayer');
    const contentDiv = document.getElementById('content');

    // 1. 讀取你產出的 JSON
    fetch('lesson.json')
        .then(res => res.json())
        .then(data => {
            renderContent(data.content);
        });

    function renderContent(sentences) {
        contentDiv.innerHTML = sentences.map((s, index) => `
            <div class="sentence" id="s-${index}" onclick="seekTo(${s.start})">
                ${s.text} <br>
                <small style="color: #666;">${s.translation}</small>
            </div>
        `).join('');

        // 2. 監聽播放時間，自動標註當前句子
        audio.ontimeupdate = () => {
            const currentTime = audio.currentTime;
            sentences.forEach((s, index) => {
                const el = document.getElementById(`s-${index}`);
                // 如果播放時間超過該句開始時間，且小於下一句開始時間
                const nextStart = sentences[index + 1] ? sentences[index + 1].start : 9999;
                if (currentTime >= s.start && currentTime < nextStart) {
                    el.classList.add('active');
                } else {
                    el.classList.remove('active');
                }
            });
        };
    }

    function seekTo(time) {
        audio.currentTime = time;
        audio.play();
    }
</script>
</body>
</html>
