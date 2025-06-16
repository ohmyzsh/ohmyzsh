#!/usr/bin/env python3
"""
Terminal Task Manager CLI - Command-line interface for task management

This module provides command-line access to the task management system.
"""

import argparse
import json
import os
import sys
from datetime import datetime, timezone
from typing import List, Dict, Optional

def humanize_time_delta(created_at: str) -> str:
    """Convert ISO timestamp to human-readable time delta using local timezone"""
    try:
        created = datetime.fromisoformat(created_at.replace('Z', '+00:00'))
        if created.tzinfo is None:
            # If no timezone info, assume it's local time
            created = created.replace(tzinfo=timezone.utc).astimezone()
        else:
            # Convert to local timezone
            created = created.astimezone()

        now = datetime.now().astimezone()
        delta = now - created

        days = delta.days
        hours = delta.seconds // 3600
        minutes = (delta.seconds % 3600) // 60

        if days > 0:
            return f"{days}d"
        elif hours > 0:
            return f"{hours}h"
        elif minutes > 0:
            return f"{minutes}m"
        else:
            return "now"
    except:
        return "?"

# ... existing code ...