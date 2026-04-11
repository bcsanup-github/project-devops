import React, { useState, useEffect } from 'react';
import './App.css';

function App() {
  const [serverStatus, setServerStatus] = useState("Checking...");
  const [data, setData] = useState([]);

  // Change this to your EC2 Public IP or "/" if using Nginx proxy
  const API_URL = "http://13.233.113.51:8000/api/status/"; 

  useEffect(() => {
    fetch(API_URL)
      .then((res) => {
        if (res.ok) return res.json();
        throw new Error("Network response was not ok.");
      })
      .then((json) => {
        setServerStatus("Online ✅");
        setData(json);
      })
      .catch((err) => {
        console.error(err);
        setServerStatus("Offline or CORS Error ❌");
      });
  }, []);

  return (
    <div className="App">
      <header className="App-header">
        <h1>DevOps Project Dashboard</h1>
        <div className="status-card">
          <p>Backend Status: <strong>{serverStatus}</strong></p>
          <p>Connected to: <code>PostgreSQL</code></p>
        </div>

        <div className="info-section">
          <h2>Project Components</h2>
          <ul style={{ listStyle: 'none', padding: 0 }}>
            <li>🚀 <strong>Frontend:</strong> React.js</li>
            <li>⚙️ <strong>Backend:</strong> Django (REST Framework)</li>
            <li>📦 <strong>Database:</strong> PostgreSQL</li>
            <li>☁️ <strong>Infrastructure:</strong> AWS EC2 (Terraform)</li>
            <li>🤖 <strong>Automation:</strong> Ansible & GitHub Actions</li>
          </ul>
        </div>

        <button 
          className="refresh-btn" 
          onClick={() => window.location.reload()}
        >
          Refresh System Status
        </button>
      </header>
    </div>
  );
}

export default App;