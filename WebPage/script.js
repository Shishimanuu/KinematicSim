const canvas = document.getElementById('animationCanvas');
const ctx = canvas.getContext('2d');
let animationId;
let simulating = false;

// Robot parameters
const robotLength = 60;  // pixels
const robotWidth = 40;   // pixels

// Simulation parameters
const dt = 0.1;
const scaleFactor = 100;  // pixels per meter

// Robot state
let eta = [0, 0, 0];  // [x, y, psi]
let t = 0;

// Trajectory storage
let trajectory = [];

function updateInputFields() {
    const driveType = document.getElementById('driveType').value;
    const wheelInputs = document.getElementById('wheelInputs');
    
    if (driveType === 'differential') {
        wheelInputs.innerHTML = `
            <div class="input-group">
                <label for="omegaL">Left Wheel Velocity (ωL):</label>
                <input type="number" id="omegaL" value="0.5" step="0.1">
            </div>
            <div class="input-group">
                <label for="omegaR">Right Wheel Velocity (ωR):</label>
                <input type="number" id="omegaR" value="0.5" step="0.1">
            </div>
        `;
    } else if (driveType === 'mecanum') {
        wheelInputs.innerHTML = `
            <div class="input-group">
                <label for="omega1">Front Left Wheel (ω1):</label>
                <input type="number" id="omega1" value="1.5" step="0.1">
                <label for="omega2">Front Right Wheel (ω2):</label>
                <input type="number" id="omega2" value="-1.5" step="0.1">
                <label for="omega3">Rear Left Wheel (ω3):</label>
                <input type="number" id="omega3" value="1.5" step="0.1">
                <label for="omega4">Rear Right Wheel (ω4):</label>
                <input type="number" id="omega4" value="-1.5" step="0.1">
            </div>
        `;
    }
}

function startSimulation() {
    if (simulating) return;
    simulating = true;
    animate();
}

function stopSimulation() {
    simulating = false;
    if (animationId) {
        cancelAnimationFrame(animationId);
    }
}

function resetSimulation() {
    stopSimulation();
    eta = [0, 0, 0];  // Reset robot position
    t = 0;
    trajectory = [];
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    drawRobot();
}

function animate() {
    if (!simulating) return;

    // Clear canvas
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    // Update robot state
    updateRobotState();

    // Draw trajectory
    drawTrajectory();

    // Draw robot
    drawRobot();

    // Continue animation
    animationId = requestAnimationFrame(animate);

    // Increment time
    t += dt;
}

function updateRobotState() {
    const driveType = document.getElementById('driveType').value;
    
    // Physical parameters
    const a = 0.3;
    const w = 0.4;
    const l = 0.6;

    let omega;
    if (driveType === 'differential') {
        const omegaL = parseFloat(document.getElementById('omegaL').value);
        const omegaR = parseFloat(document.getElementById('omegaR').value);
        omega = [omegaL, omegaR];
    } else if (driveType === 'mecanum') {
        const omega1 = parseFloat(document.getElementById('omega1').value);
        const omega2 = parseFloat(document.getElementById('omega2').value);
        const omega3 = parseFloat(document.getElementById('omega3').value);
        const omega4 = parseFloat(document.getElementById('omega4').value);
        omega = [omega1, omega2, omega3, omega4];
    }

    const psi = eta[2];
    const j_psi = [
        [Math.cos(psi), -Math.sin(psi), 0],
        [Math.sin(psi), Math.cos(psi), 0],
        [0, 0, 1]
    ];

    let W;
    if (driveType === 'differential') {
        W = [
            [a/2, a/2],
            [0, 0],
            [-a/(w), a/(w)]
        ];
    } else if (driveType === 'mecanum') {
        W = [
            [a/4, a/4, a/4, a/4],
            [a/4, -a/4, a/4, -a/4],
            [-a/(4*(l+w)), -a/(4*(l+w)), a/(4*(l+w)), a/(4*(l+w))]
        ];
    }

    const zeta = multiplyMatrices(W, omega);
    const eta_dot = multiplyMatrices(j_psi, zeta);

    for (let j = 0; j < 3; j++) {
        eta[j] += dt * eta_dot[j];
    }

    // Boundary checking
    const margin = robotLength / 2 / scaleFactor;
    eta[0] = Math.max(-canvas.width / (2 * scaleFactor) + margin, Math.min(canvas.width / (2 * scaleFactor) - margin, eta[0]));
    eta[1] = Math.max(-canvas.height / (2 * scaleFactor) + margin, Math.min(canvas.height / (2 * scaleFactor) - margin, eta[1]));

    // Store trajectory point
    trajectory.push([eta[0], eta[1]]);
}

function drawRobot() {
    const x = eta[0] * scaleFactor + canvas.width / 2;
    const y = -eta[1] * scaleFactor + canvas.height / 2;  // Invert y-axis

    ctx.save();
    ctx.translate(x, y);
    ctx.rotate(-eta[2]);  // Negative rotation to match coordinate system

    ctx.fillStyle = 'blue';
    ctx.fillRect(-robotLength/2, -robotWidth/2, robotLength, robotWidth);

    // Draw direction indicator
    ctx.beginPath();
    ctx.moveTo(robotLength/2, 0);
    ctx.lineTo(robotLength/2 + 10, -5);
    ctx.lineTo(robotLength/2 + 10, 5);
    ctx.closePath();
    ctx.fillStyle = 'red';
    ctx.fill();

    ctx.restore();
}

function drawTrajectory() {
    ctx.beginPath();
    trajectory.forEach((point, index) => {
        const x = point[0] * scaleFactor + canvas.width / 2;
        const y = -point[1] * scaleFactor + canvas.height / 2;  // Invert y-axis
        if (index === 0) {
            ctx.moveTo(x, y);
        } else {
            ctx.lineTo(x, y);
        }
    });
    ctx.strokeStyle = 'green';
    ctx.stroke();
}

function multiplyMatrices(a, b) {
    if (Array.isArray(b[0])) {
        return a.map(row => b[0].map((_, i) => row.reduce((sum, el, j) => sum + el * b[j][i], 0)));
    } else {
        return a.map(row => row.reduce((sum, el, i) => sum + el * b[i], 0));
    }
}

// Event listeners
document.getElementById('driveType').addEventListener('change', updateInputFields);
document.getElementById('startButton').addEventListener('click', startSimulation);
document.getElementById('stopButton').addEventListener('click', stopSimulation);
document.getElementById('resetButton').addEventListener('click', resetSimulation);

// Initialize input fields and draw initial robot position
updateInputFields();
drawRobot();