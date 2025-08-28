#!/bin/bash
# 图3：消融研究实验: 添加多头注意力
# 科学目的：通过逐步添加关键训练机制，验证各组件对多无人机避障导航性能的贡献。
# 设置说明：然后依次添加：(1) 多头注意力模块，(2) 基于SDF的障碍物观测，将其替换为无障碍感知。每种设置下均训练1e9环境步长，比较成功率、碰撞率等指标的变化。
# 2. 添加多头注意力: 使用多头注意力编码，其余与完整方法相同。
#!/usr/bin/env bash
python -m swarm_rl.train \
  --env=quadrotor_multi --train_for_env_steps=1000000000 \
  --algo=APPO --use_rnn=False \
  --num_workers=8 --num_envs_per_worker=4 \
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
  --anneal_collision_steps=300000000 --replay_buffer_sample_prob=0.0 \
  --quads_mode=mix --quads_episode_duration=15.0 \
  --quads_num_agents=8 \
  --quads_obs_repr=xyz_vxyz_R_omega_floor \
  --quads_neighbor_hidden_size=256 --quads_neighbor_obs_type=pos_vel \
  --quads_neighbor_encoder_type=attention --quads_neighbor_visible_num=2 \
  --quads_collision_hitbox_radius=2.0 --quads_collision_falloff_radius=4.0 \
  --quads_collision_reward=5.0 --quads_collision_smooth_max_penalty=4.0 \
  --quads_use_obstacles=True --quads_obst_spawn_area 8 8 \
  --quads_obst_density=0.2 --quads_obst_size=0.6 \
  --quads_obst_collision_reward=5.0 --quads_obstacle_obs_type=octomap \
  --quads_use_downwash=True \
  --experiment=fig3_no_replay

