import Phaser from 'phaser';

// Game configuration
const config = {
    type: Phaser.AUTO,
    width: 800,
    height: 600,
    parent: 'game-container',
    backgroundColor: '#87CEEB',
    physics: {
        default: 'arcade',
        arcade: {
            gravity: { y: 1000 },
            debug: false
        }
    },
    scene: {
        preload: preload,
        create: create,
        update: update
    }
};

// Game state
let player;
let ground;
let obstacles;
let cursors;
let spaceKey;
let score = 0;
let lives = 5;
let gameSpeed = 300;
let obstacleTimer = 0;
let canDoubleJump = true;
let hasDoubleJumped = false;
let scoreText;
let livesText;
let gameOverText;
let isGameOver = false;

const game = new Phaser.Game(config);

function preload() {
    // We'll use simple shapes for now (no images needed)
}

function create() {
    // Create ground
    ground = this.physics.add.staticGroup();

    // Create ground tiles
    for (let i = 0; i < 10; i++) {
        const groundTile = this.add.rectangle(i * 80, 580, 80, 40, 0x8B4513);
        ground.add(groundTile);
    }

    // Create player (simple square)
    player = this.add.rectangle(100, 500, 30, 30, 0xFF0000);
    this.physics.add.existing(player);
    player.body.setCollideWorldBounds(true);
    player.body.setBounce(0);

    // Create obstacles group
    obstacles = this.physics.add.group();

    // Collisions
    this.physics.add.collider(player, ground);
    this.physics.add.overlap(player, obstacles, hitObstacle, null, this);

    // Input
    cursors = this.input.keyboard.createCursorKeys();
    spaceKey = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.SPACE);

    // Mouse/touch input
    this.input.on('pointerdown', jump, this);

    // UI Text
    scoreText = this.add.text(16, 16, 'Score: 0', {
        fontSize: '24px',
        fill: '#000',
        fontStyle: 'bold'
    });

    livesText = this.add.text(16, 50, 'Lives: 5', {
        fontSize: '24px',
        fill: '#000',
        fontStyle: 'bold'
    });

    // Instructions
    this.add.text(400, 16, 'SPACE or CLICK to Jump!', {
        fontSize: '20px',
        fill: '#000',
        fontStyle: 'bold'
    }).setOrigin(0.5, 0);

    this.add.text(400, 50, 'Double Jump Available!', {
        fontSize: '18px',
        fill: '#00FF00',
        fontStyle: 'bold'
    }).setOrigin(0.5, 0);
}

function update(time, delta) {
    if (isGameOver) {
        return;
    }

    // Increase score over time
    score += 1;
    scoreText.setText('Score: ' + Math.floor(score / 10));

    // Spawn obstacles
    obstacleTimer += delta;
    if (obstacleTimer > 1500) {
        spawnObstacle(this);
        obstacleTimer = 0;
    }

    // Move and remove obstacles
    obstacles.children.entries.forEach(obstacle => {
        obstacle.x -= gameSpeed * delta / 1000;

        if (obstacle.x < -50) {
            obstacle.destroy();
        }
    });

    // Jump input
    if (Phaser.Input.Keyboard.JustDown(spaceKey)) {
        jump.call(this);
    }

    // Reset double jump when on ground
    if (player.body.touching.down) {
        hasDoubleJumped = false;
    }

    // Gradually increase difficulty
    if (score % 500 === 0 && score > 0) {
        gameSpeed += 10;
    }
}

function jump() {
    if (isGameOver) return;

    // First jump (on ground)
    if (player.body.touching.down) {
        player.body.setVelocityY(-500);
        hasDoubleJumped = false;
    }
    // Double jump (in air)
    else if (canDoubleJump && !hasDoubleJumped) {
        player.body.setVelocityY(-450);
        hasDoubleJumped = true;
    }
}

function spawnObstacle(scene) {
    const obstacleHeight = Phaser.Math.Between(30, 60);
    const obstacle = scene.add.rectangle(850, 550 - obstacleHeight / 2, 30, obstacleHeight, 0x00FF00);

    scene.physics.add.existing(obstacle);
    obstacle.body.setAllowGravity(false);
    obstacle.body.setImmovable(true);

    obstacles.add(obstacle);
}

function hitObstacle(player, obstacle) {
    // Remove the obstacle
    obstacle.destroy();

    // Decrease lives
    lives -= 1;
    livesText.setText('Lives: ' + lives);

    // Flash player red
    player.fillColor = 0xFFFFFF;
    setTimeout(() => {
        if (!isGameOver) {
            player.fillColor = 0xFF0000;
        }
    }, 100);

    // Check game over
    if (lives <= 0) {
        gameOver(this);
    }
}

function gameOver(scene) {
    isGameOver = true;

    // Stop physics
    scene.physics.pause();

    // Change player color
    player.fillColor = 0x666666;

    // Show game over text
    gameOverText = scene.add.text(400, 300, 'GAME OVER\n\nScore: ' + Math.floor(score / 10) + '\n\nRefresh to Play Again', {
        fontSize: '48px',
        fill: '#FF0000',
        align: 'center',
        fontStyle: 'bold',
        stroke: '#000',
        strokeThickness: 6
    });
    gameOverText.setOrigin(0.5);
}
