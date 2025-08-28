#!/bin/bash
# 图7：智能体数量扩展性实验  
# 科学目的：评估算法随无人机数量扩展的性能，在包含静态障碍物的复杂环境下验证可扩展性。
# 设置说明：保持标准障碍物环境（密度0.2，尺寸0.6m），邻居感知数量K=2，逐步增加无人机总数N＝4、8、16、32，运行1e9步训练以观察成功率和碰撞率等指标随N的变化趋势。
#!/usr/bin/env bash
# 用法：bash scale_agents_X.sh 32   # 8|16|32
N=${1:-8}

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
  --anneal_collision_steps=300000000 --replay_buffer_sample_prob=0.75 \
  --quads_mode=mix --quads_episode_duration=15.0 \
  --quads_num_agents=${N} \
  --quads_obs_repr=xyz_vxyz_R_omega_floor \
  --quads_neighbor_hidden_size=256 --quads_neighbor_obs_type=pos_vel \
  --quads_neighbor_encoder_type=attention --quads_neighbor_visible_num=2 \
  --quads_collision_hitbox_radius=2.0 --quads_collision_falloff_radius=4.0 \
  --quads_collision_reward=5.0 --quads_collision_smooth_max_penalty=4.0 \
  --quads_use_obstacles=True --quads_obst_spawn_area 8 8 \
  --quads_obst_density=0.2 --quads_obst_size=0.6 \
  --quads_obst_collision_reward=5.0 --quads_obstacle_obs_type=octomap \
  --quads_use_downwash=True \
  --experiment=scale_agents_${N}
