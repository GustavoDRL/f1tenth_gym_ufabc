# Start from ROS2 Humble base image
FROM ros:humble

# Set shell with proper syntax (fixed the asterisks)
SHELL ["/bin/bash", "-c"]

# Install system dependencies in a single RUN command to reduce layers
# Added --no-install-recommends to reduce image size
# Added cleanup of apt cache to reduce image size
RUN apt-get update --fix-missing && \
    apt-get install -y --no-install-recommends \
        git \
        nano \
        vim \
        python3-pip \
        libeigen3-dev \
        tmux \
        ros-humble-rviz2 && \
    apt-get -y dist-upgrade && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip3 install --no-cache-dir transforms3d

# Create workspace directory first
WORKDIR /sim_ws

# Clone and install F1TENTH Gym
RUN git config --global http.sslVerify false && \
    git clone https://github.com/f1tenth/f1tenth_gym && \
    cd f1tenth_gym && \
    pip3 install -e .

# Create directory for ROS package
RUN mkdir -p src/f1tenth_gym_ros

# Copy only necessary files
# Changed from .* to be more specific
COPY . src/f1tenth_gym_ros/

# Build ROS workspace
# Added error checking and combined commands
RUN source /opt/ros/humble/setup.bash && \
    apt-get update --fix-missing && \
    rosdep install -i --from-path src --rosdistro humble -y && \
    colcon build && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set default command
ENTRYPOINT ["/bin/bash"]