#!/usr/bin/env python3
"""
Dino Animation Module for Taskman
Chrome dino-style game with enhanced physics and visual effects
"""

import random
import time
import math


class DinoAnimation:
    """Enhanced Chrome dino-style animation with physics-based jumping"""

    def __init__(self, width: int):
        self.width = width - 10  # Leave margin for UI
        self.enabled = False
        self.last_update = 0

        # Player state
        self.player_pos = 8  # Fixed horizontal position
        self.is_jumping = False
        self.jump_velocity = 0  # Vertical velocity
        self.jump_height = 0   # Current height
        self.gravity = 0.6     # Reduced gravity for more natural feel
        self.ground_level = 0  # Ground level
        self.initial_jump_velocity = 2.8  # Reduced initial jump velocity

        # Animation state
        self.frame_counter = 0
        self.player_sprites = ["●", "○", "●", "◐"]  # Running animation
        self.jump_sprite = "◆"

        # Game elements
        self.obstacles = []
        self.clouds = []
        self.ground_dots = []
        self.obstacle_spawn_timer = 0

        # Game state
        self.game_over = False
        self.game_over_timer = 0
        self.score = 0

        # State tracking for flicker reduction
        self._last_display_state = None
        self._display_cache = None
        self._state_changed = True

        # Initialize ground pattern
        self._init_ground()
        self._init_obstacle_types()
        self._init_cloud_patterns()

    def _init_ground(self):
        """Initialize scrolling ground pattern"""
        ground_chars = [".", "·", "˙", "∘"]
        for i in range(self.width + 20):
            self.ground_dots.append({
                'x': i * 2,
                'char': random.choice(ground_chars),
                'speed': 1.0
            })

    def _init_obstacle_types(self):
        """Initialize obstacle types with ASCII art for tall obstacles"""
        self.obstacle_types = [
            # Low ground obstacles (height 1) - single element
            {'type': 'ground_low', 'height': 1, 'chars': ['|', '┃', '▌', '█', '▐', '║']},

            # Medium ground obstacles (height 1) - single emoji elements
            {'type': 'ground_medium', 'height': 1, 'chars': ['🌵', '🪨', '🗿']},

            # Tall ground obstacles (height 2) - ASCII art stacked
            {'type': 'ground_tall', 'height': 2, 'chars': [
                {'base': '/|\\', 'top': '/^\\'},      # Mountain peak
                {'base': '|||', 'top': '═══'},       # Building with roof
                {'base': '▓▓▓', 'top': '^^^'},       # Rock formation
                {'base': '│█│', 'top': '┌─┐'},       # Tower
                {'base': '/█\\', 'top': ' ○ '},       # Tree with crown
                {'base': '▀▀▀', 'top': '┬┬┬'},       # Fence/barrier
            ]},

            # Flying obstacles (height 2-3) - appear in air
            {'type': 'flying', 'height': 0, 'chars': ['🦅', '✈️', '🚁', '🛸', '◊', '▲', '●']}
        ]

    def _init_cloud_patterns(self):
        """Initialize cloud patterns for background"""
        self.cloud_patterns = ['☁', '☁️', '⛅']  # Removed sun and moving elements

    def _start_jump(self):
        """Start a jump with realistic physics"""
        if not self.is_jumping:
            self.is_jumping = True
            self.jump_velocity = self.initial_jump_velocity
            self.jump_height = 0

    def _update_jump_physics(self):
        """Update jump physics with realistic gravity"""
        if self.is_jumping:
            # Update position based on velocity
            self.jump_height += self.jump_velocity

            # Apply gravity (decelerate upward velocity)
            self.jump_velocity -= self.gravity

            # Land when hitting ground
            if self.jump_height <= self.ground_level:
                self.jump_height = self.ground_level
                self.is_jumping = False
                self.jump_velocity = 0

    def _spawn_obstacle(self):
        """Spawn a new obstacle at the right edge"""
        if len(self.obstacles) < 3:  # Reduced obstacle limit for less density
            # Reduce flying obstacles frequency
            ground_types = [t for t in self.obstacle_types if t['type'] != 'flying']
            flying_types = [t for t in self.obstacle_types if t['type'] == 'flying']

            # 80% chance for ground obstacles, 20% for flying
            if random.random() < 0.8:
                obstacle_type = random.choice(ground_types)
            else:
                obstacle_type = random.choice(flying_types)

            # Handle different obstacle char structures
            if obstacle_type['type'] == 'ground_tall':
                # For tall obstacles, pick a stacked pair
                obstacle_char = random.choice(obstacle_type['chars'])
            else:
                # For simple obstacles, pick a single char
                obstacle_char = random.choice(obstacle_type['chars'])

            # Spawn at right edge with more spacing
            spawn_x = self.width + random.randint(15, 40)  # Increased spacing

            # Determine height based on obstacle type
            if obstacle_type['type'] == 'flying':
                height = random.choice([2, 3])  # Flying obstacles at height 2-3
            else:
                height = obstacle_type['height']

            self.obstacles.append({
                'x': spawn_x,
                'char': obstacle_char,
                'height': height,
                'type': obstacle_type['type'],
                'speed': random.uniform(1.0, 2.0)  # Slower speed range
            })

    def _spawn_cloud(self):
        """Spawn background clouds for atmosphere"""
        if len(self.clouds) < 2:  # Reduced cloud limit
            cloud_char = random.choice(self.cloud_patterns)
            spawn_x = self.width + random.randint(20, 60)  # More spacing between clouds
            self.clouds.append({
                'x': spawn_x,
                'char': cloud_char,
                'speed': random.uniform(0.1, 0.3)  # Much slower cloud movement for background effect
            })

    def _check_collision(self):
        """Check for collisions between player and obstacles"""
        if self.is_jumping:
            player_height = int(self.jump_height) + 1
        else:
            player_height = 0

        for obstacle in self.obstacles:
            # Only check collision with ground-based obstacles
            if obstacle['type'] in ['ground_low', 'ground_medium', 'ground_tall']:
                # Calculate obstacle width for ASCII art
                obstacle_width = 1
                if obstacle['type'] == 'ground_tall' and isinstance(obstacle['char'], dict):
                    if 'base' in obstacle['char']:
                        obstacle_width = len(obstacle['char']['base'])

                # Check horizontal collision with obstacle width
                for i in range(obstacle_width):
                    if abs((obstacle['x'] + i) - self.player_pos) <= 1:
                        # Check vertical collision
                        obstacle_top = obstacle['height']
                        if player_height < obstacle_top:
                            self.game_over = True
                            self.game_over_timer = 45  # 3.6 seconds at 80ms intervals
                            return True
            # Flying obstacles don't cause collisions - player passes underneath
        return False

    def _reset_game(self):
        """Reset game state after game over"""
        self.game_over = False
        self.obstacles.clear()
        self.clouds.clear()
        self.score = 0
        self.is_jumping = False
        self.jump_velocity = 0
        self.jump_height = 0
        self.obstacle_spawn_timer = 0

    def toggle_animation(self):
        """Toggle animation on/off"""
        self.enabled = not self.enabled
        if not self.enabled:
            self._reset_game()
        return self.enabled

    def is_enabled(self):
        """Check if animation is enabled"""
        return self.enabled

    def _get_display_state_hash(self):
        """Generate a hash of the current display state to detect changes"""
        state_data = []

        # Player state
        state_data.append(f"player:{self.player_pos}:{self.is_jumping}:{int(self.jump_height)}:{self.game_over}")

        # Obstacles
        for obs in self.obstacles:
            state_data.append(f"obs:{int(obs['x'])}:{obs['char']}:{obs['height']}")

        # Clouds (only position matters for display)
        for cloud in self.clouds:
            state_data.append(f"cloud:{int(cloud['x'])}:{cloud['char']}")

        # Frame counter for animation
        sprite_index = (self.frame_counter // 3) % len(self.player_sprites)
        state_data.append(f"frame:{sprite_index}")

        return hash(tuple(state_data))

    def update(self):
        """Update animation state with improved physics and state tracking"""
        if not self.enabled:
            return

        current_time = time.time()
        # Slower animation: update every 80ms for more relaxed pace
        if current_time - self.last_update < 0.08:
            return

        self.last_update = current_time
        old_state_hash = self._get_display_state_hash()

        # Handle game over state
        if self.game_over:
            if self.game_over_timer > 0:
                self.game_over_timer -= 1
            else:
                self._reset_game()
            # Check if state changed
            new_state_hash = self._get_display_state_hash()
            self._state_changed = (old_state_hash != new_state_hash)
            return

        # Update frame counter for animations
        self.frame_counter += 1

        # Update jump physics
        self._update_jump_physics()

        # Smart auto-jump logic - only jump for ground obstacles
        if not self.is_jumping:
            for obstacle in self.obstacles:
                # Only jump for obstacles that are on the ground or blocking the path
                if obstacle['type'] in ['ground_low', 'ground_medium', 'ground_tall']:
                    distance = obstacle['x'] - self.player_pos
                    if 4 <= distance <= 7:  # Reasonable jump timing window
                        self._start_jump()
                        break
                # Flying obstacles don't require jumping - player passes underneath

        # Move obstacles
        obstacles_changed = False
        for obstacle in self.obstacles[:]:
            old_x = obstacle['x']
            obstacle['x'] -= obstacle['speed']
            if obstacle['x'] < -5:
                self.obstacles.remove(obstacle)
                self.score += 1
                obstacles_changed = True
            elif int(old_x) != int(obstacle['x']):  # Only flag change if integer position changed
                obstacles_changed = True

        # Move clouds
        clouds_changed = False
        for cloud in self.clouds[:]:
            old_x = cloud['x']
            cloud['x'] -= cloud['speed']
            if cloud['x'] < -10:
                self.clouds.remove(cloud)
                clouds_changed = True
            elif int(old_x) != int(cloud['x']):  # Only flag change if integer position changed
                clouds_changed = True

        # Move ground dots (these don't affect display state hash, so no tracking needed)
        for dot in self.ground_dots:
            dot['x'] -= dot['speed']
            if dot['x'] < -5:
                dot['x'] = self.width + 5

        # Spawn new obstacles and clouds with better timing
        self.obstacle_spawn_timer += 1
        if self.obstacle_spawn_timer >= random.randint(15, 25):  # Much less frequent spawning
            self._spawn_obstacle()
            self.obstacle_spawn_timer = 0
            obstacles_changed = True

        # Spawn clouds less frequently
        if random.random() < 0.05:  # 5% chance each update (reduced from 10%)
            self._spawn_cloud()
            clouds_changed = True

        # Check collisions
        collision_occurred = self._check_collision()

        # Determine if display state changed
        new_state_hash = self._get_display_state_hash()
        self._state_changed = (
            old_state_hash != new_state_hash or
            obstacles_changed or
            clouds_changed or
            collision_occurred
        )

    def has_display_changed(self):
        """Check if the display state has changed since last check"""
        return self._state_changed

    def get_display_lines(self) -> tuple:
        """Generate all 6 display lines for the animation with caching"""
        if not self.enabled:
            return ("", "", "", "", "", "")

        # Return cached display if state hasn't changed
        if not self._state_changed and self._display_cache is not None:
            return self._display_cache

        # Generate new display
        display_lines = self._generate_display_lines()

        # Cache the result
        self._display_cache = display_lines
        self._state_changed = False

        return display_lines

    def _generate_display_lines(self) -> tuple:
        """Generate all 6 display lines for the animation"""
        if not self.enabled:
            return ("", "", "", "", "", "")

        # Initialize all lines
        sky_line = [' '] * self.width
        high_line = [' '] * self.width
        mid_line = [' '] * self.width
        jump_line = [' '] * self.width
        ground_line = [' '] * self.width
        base_line = [' '] * self.width

        # Draw clouds fixed in sky layer only
        for cloud in self.clouds:
            x = int(cloud['x'])
            if 0 <= x < self.width and x < len(sky_line):
                sky_line[x] = cloud['char']

        # Draw obstacles at appropriate heights
        for obstacle in self.obstacles:
            x = int(obstacle['x'])
            if 0 <= x < self.width:
                height = obstacle['height']
                char = obstacle['char']

                if obstacle['type'] == 'flying':
                    # Flying obstacles appear in high layers only
                    if height == 3 and x < len(sky_line):
                        sky_line[x] = char
                    elif height == 2 and x < len(high_line):
                        high_line[x] = char
                elif obstacle['type'] == 'ground_tall':
                    # Tall obstacles use ASCII art stacked display
                    if isinstance(char, dict) and 'base' in char and 'top' in char:
                        base_art = char['base']
                        top_art = char['top']

                        # Draw multi-character ASCII art
                        for i, c in enumerate(base_art):
                            if x + i < len(ground_line):
                                ground_line[x + i] = c

                        for i, c in enumerate(top_art):
                            if x + i < len(jump_line):
                                jump_line[x + i] = c
                    else:
                        # Fallback for simple char
                        if x < len(ground_line):
                            ground_line[x] = char
                else:
                    # Simple ground obstacles (height 1)
                    if x < len(ground_line):
                        ground_line[x] = char

        # Draw player
        if self.player_pos < self.width:
            if self.game_over:
                # Game over state
                if self.player_pos < len(ground_line):
                    ground_line[self.player_pos] = '✗'
            elif self.is_jumping:
                # Calculate which line to draw player on based on jump height
                # Use more reasonable height mapping
                if self.jump_height >= 3:
                    # Very high jump - sky line
                    if self.player_pos < len(high_line):
                        high_line[self.player_pos] = self.jump_sprite
                    # Add trail at previous height
                    if self.player_pos > 0 and mid_line[self.player_pos - 1] == ' ':
                        mid_line[self.player_pos - 1] = '·'
                elif self.jump_height >= 2:
                    # Medium jump - mid line
                    if self.player_pos < len(mid_line):
                        mid_line[self.player_pos] = self.jump_sprite
                    # Add trail at previous height
                    if self.player_pos > 0 and jump_line[self.player_pos - 1] == ' ':
                        jump_line[self.player_pos - 1] = '·'
                elif self.jump_height >= 1:
                    # Low jump - jump line
                    if self.player_pos < len(jump_line):
                        jump_line[self.player_pos] = self.jump_sprite
                    # Add trail at ground level
                    if self.player_pos > 0 and ground_line[self.player_pos - 1] == ' ':
                        ground_line[self.player_pos - 1] = '·'
                else:
                    # Just off ground - still on ground line
                    if self.player_pos < len(ground_line):
                        ground_line[self.player_pos] = self.jump_sprite
            else:
                # Running animation
                sprite_index = (self.frame_counter // 3) % len(self.player_sprites)
                if self.player_pos < len(ground_line):
                    ground_line[self.player_pos] = self.player_sprites[sprite_index]

        # Draw ground pattern
        for dot in self.ground_dots:
            x = int(dot['x'])
            if 0 <= x < self.width and x < len(base_line):
                if base_line[x] == ' ':  # Don't overwrite other elements
                    base_line[x] = dot['char']

        # Convert to strings
        return (
            ''.join(sky_line),
            ''.join(high_line),
            ''.join(mid_line),
            ''.join(jump_line),
            ''.join(ground_line),
            ''.join(base_line)
        )

    def get_status(self) -> str:
        """Get current game status"""
        if not self.enabled:
            return "Animation: OFF (press 'x' to enable)"

        if self.game_over:
            return f"Game Over! Score: {self.score} (restarting...)"

        player_state = 'Jumping' if self.is_jumping else 'Running'
        return f"Dino Game: {player_state} | Score: {self.score} | Press 'x' to toggle"