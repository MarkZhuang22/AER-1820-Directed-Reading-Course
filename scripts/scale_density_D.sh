#!/bin/bash
# 图9：静态障碍物密度扩增实验
# 科学目的：测试环境中障碍物密度D升高对多机避障策略的影响。当障碍物半径固定为0.6 m时，增加单位面积内障碍物的密度（D = 0.1, 0.2, 0.4, 0.6, 0.8）以观察成功率和碰撞率的变化。
# 设置说明：无人机总数维持8架（默认值），邻居感知数K=2（完整方法配置），障碍物尺寸固定0.6 m。逐步提高障碍物密度D并分别训练，每次1e9环境步长。环境其余参数与完整方法一致。
#!/usr/bin/env bash
# 用法：bash scale_density_D.sh 0.4   # 0.2|0.4|0.6|0.8
D=${1:-0.2}; label=${D//./p}

python -m swarm_rl.train \
  --env=quadrotor_multi --train_for_env_steps=1000000000 \
  --algo=APPO --use_rnn=False \
  --num_workers=4 --num_envs_per_worker=4 \
  --learning_rate=1e-4 --ppo_clip_value=5.0 --recurrence=1 \
  --nonlinearity=tanh --actor_critic_share_weights=False \
  --policy_initialization=xavier_uniform \
  --adaptive_stddev=False --with_vtrace=False \
  --max_policy_lag=100000000 --rnn_size=256 \
  --gae_lambda=1.0 --max_grad_norm=5.0 \
  --exploration_loss_coeff=0.0 --rollout=128 --batch_size=1024 \
  --with_pbt=False --normalize_input=False --normalize_returns=False \
  --reward_clip=10 \
  --quads_use_numba=True --save_milestones_sec=3600 \
  --anneal_collision_steps=300000000 --replay_buffer_sample_prob=0.75 \
  --quads_mode=mix --quads_episode_duration=15.0 \
  --quads_num_agents=8 \
  --quads_obs_repr=xyz_vxyz_R_omega_floor \
  --quads_neighbor_hidden_size=256 --quads_neighbor_obs_type=pos_vel \
  --quads_neighbor_encoder_type=attention --quads_encoder_type=attention \
  --quads_neighbor_visible_num=2 \
  --quads_collision_hitbox_radius=2.0 --quads_collision_falloff_radius=4.0 \
  --quads_collision_reward=5.0 --quads_collision_smooth_max_penalty=4.0 \
  --quads_use_obstacles=True --quads_obst_spawn_area 8 8 \
  --quads_obst_density=$D --quads_obst_size=0.6 \
  --quads_obst_collision_reward=5.0 --quads_obstacle_obs_type=octomap \
  --quads_use_downwash=True \
  --experiment=scale_density_${label}

