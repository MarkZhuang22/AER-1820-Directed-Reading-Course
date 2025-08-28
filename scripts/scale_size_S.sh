#!/bin/bash
# 图10：障碍物尺寸扩增实验
# 科学目的：评估障碍物尺寸增大对多机导航的影响。当障碍物密度固定为0.2时，逐步增大障碍物半径 S = 0.6, 0.7, 0.8, 0.85 m，观察成功率在更狭窄通道下的变化趋势。
# 设置说明：无人机总数8架，邻居感知K=2，障碍物密度固定0.2。其余训练超参数与完整方法一致。脚本循环增大障碍物尺寸S并分别运行训练，每次1e9环境步长。
#!/usr/bin/env bash
# 用法：bash scale_size_S.sh 0.8   # 0.6|0.7|0.8|0.85
S=${1:-0.6}; label=${S//./p}

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
  --quads_obst_density=0.8 --quads_obst_size=$S \
  --quads_obst_collision_reward=5.0 --quads_obstacle_obs_type=octomap \
  --quads_use_downwash=True \
  --experiment=scale_size_${label}
