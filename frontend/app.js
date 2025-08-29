
document.addEventListener("DOMContentLoaded", () => {
  const container = document.getElementById("alertContainer");

  const alert = {
    alarmName: "RootLoginWithoutMFA",
    state: "ALARM",
    region: "us-east-1",
    reason: "Root account used without MFA",
    time: "2025-08-29T08:15:30Z"
  };

  const html = `
    <div class="alert-card">
      <h5>🚨 ${alert.alarmName}</h5>
      <p><strong>State:</strong> ${alert.state}</p>
      <p><strong>Region:</strong> ${alert.region}</p>
      <p><strong>Reason:</strong> ${alert.reason}</p>
      <p><strong>Time:</strong> ${alert.time}</p>
    </div>
  `;

  container.innerHTML = html;
});
