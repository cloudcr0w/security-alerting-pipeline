document.addEventListener("DOMContentLoaded", () => {
  const container = document.getElementById("alertContainer");

  const alerts = [
    {
      alarmName: "RootLoginWithoutMFA",
      state: "ALARM",
      region: "us-east-1",
      reason: "Root account used without MFA",
      time: "2025-08-29T08:15:30Z"
    },
    {
      alarmName: "PublicS3Bucket",
      state: "OK",
      region: "eu-west-1",
      reason: "Bucket policy corrected",
      time: "2025-08-29T08:18:10Z"
    },
    {
      alarmName: "PortScanDetected",
      state: "INSUFFICIENT_DATA",
      region: "ap-southeast-2",
      reason: "Scan activity inconclusive",
      time: "2025-08-29T08:20:42Z"
    }
  ];

  const emojiMap = {
    ALARM: "🚨",
    OK: "✅",
    INSUFFICIENT_DATA: "⚠️"
  };

  const stateClassMap = {
    ALARM: "alert-card",
    OK: "alert-card alert-state-ok",
    INSUFFICIENT_DATA: "alert-card alert-state-warning"
  };

  container.innerHTML = alerts.map(alert => {
    const emoji = emojiMap[alert.state] || "❓";
    const cardClass = stateClassMap[alert.state] || "alert-card";

    return `
      <div class="${cardClass}">
        <h5>${emoji} ${alert.alarmName}</h5>
        <p><strong>State:</strong> ${alert.state}</p>
        <p><strong>Region:</strong> ${alert.region}</p>
        <p><strong>Reason:</strong> ${alert.reason}</p>
        <p><strong>Time:</strong> ${alert.time}</p>
      </div>
    `;
  }).join("");
});
document.getElementById("reloadButton").addEventListener("click", () => {
  location.reload();
});
