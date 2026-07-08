# Enemy・Boss・EnemyBullet クラス設計

## 担当者
亀田 佳太

---

# Enemy

## 概要
通常の敵を管理するクラス。

## 属性
- x : X座標
- y : Y座標
- hp : 体力
- speed : 移動速度
- weakType : 弱点属性
- alive : 生存判定

## メソッド
- move() : 敵を移動する
- attack() : 敵の弾を発射する
- damage(int bulletType) : 弱点属性ならダメージを受ける
- display() : 敵を描画する

## メモ
通常敵を管理するクラス。プレイヤーに向かって移動し、一定時間ごとに弾を発射する。

---

# Boss（Enemyを継承）

## 属性
- hp : ボスの体力
- weakType : 現在の弱点属性
- phase : ボスの攻撃段階

## メソッド
- attack() : ボス専用の攻撃
- changeWeakType() : 弱点属性を変更する
- specialAttack() : 特殊攻撃
- display() : ボスを描画する

## メモ
Enemyクラスを継承し、通常敵より高い体力を持つ。体力が一定以下になると弱点属性が変化する。

---

# EnemyBullet

## 属性
- x : X座標
- y : Y座標
- speed : 弾速
- active : 発射中かどうか

## メソッド
- move() : 弾を移動する
- display() : 弾を描画する
- hitPlayer() : プレイヤーとの当たり判定

## メモ
敵が発射する弾を管理するクラス。