# System Overview — Quality for Biters!
`docs/SystemSpecification/00_Overview.md`

**Status:** Active  
**Scope:** Quality for Biters!

---

# 0. 本書の目的

本書は Quality for Biters!（以下 QFB）における  
**SystemSpecification 全体の入口（Overview）**として機能する。

本書は以下を整理する。

- QFB が **どのようなシステムであるか**
- システムの **責務と境界**
- システムの **実行モデル**
- システム仕様文書の構成

本書は **個別挙動の詳細を定義しない。**

確率式、対象判定、品質計算などの詳細は  
実装または将来の SystemSpecification 文書に委譲する。

---

# 1. システムの全体像

Quality for Biters! は、

> **敵ユニットに「品質」軸を導入し、進化度に応じて戦闘圧力を段階的に増加させる Mod**

である。

QFB は敵エンティティに対して  
**品質（Quality）を確率的に付与する処理**を行う。

品質は次の要素に基づいて決定される。

- 敵進化度（Evolution Factor）
- Deterministic Random
- 品質チェーン（normal → … → legendary）

これにより、ゲーム進行に伴って

- より強力な敵個体
- 戦闘の不確実性
- 終盤戦の持続的圧力

が発生する。

---

# 2. プレイヤー体験

QFB は次のプレイヤー体験を目的とする。

- 戦闘の多様性の増加
- 終盤戦の圧力強化
- 予測不能な戦闘状況

本 Mod は次の設計方針を持つ。

- **序盤の難易度を大きく上げない**
- **瞬間的な詰みを発生させない**
- **持続的な戦闘圧力を形成する**

品質の高い敵個体は  
ゲーム進行に伴い徐々に出現率が上昇する。

---

# 3. システム責務

QFB の責務は次の通り。

| Responsibility | Owner |
|---|---|
| 対象敵エンティティの判定 | QFB |
| 敵進化度の取得 | QFB |
| 品質抽選（Deterministic RNG） | QFB |
| 品質付きエンティティへの置換 | QFB |

QFB は次を責務としない。

- 敵 AI の変更
- 敵スポーンシステムの変更
- 敵勢力行動ロジックの変更
- 戦闘バランス全体の再設計

本 Mod は **既存敵システムの挙動を維持したまま、個体品質のみを変更する。**

---

# 4. 実行モデル

QFB は **イベント駆動型システム**として動作する。

主な処理は次のイベントを契機に実行される。

```
chunk generated
↓
対象 enemy entity 検出
↓
品質抽選
↓
必要ならエンティティ置換
```

```
enemy entity spawned
↓
品質抽選
↓
必要ならエンティティ置換
```

QFB は

- job scheduler
- tick driver
- global planning

を持たない。

---

# 5. 主要メカニズム

品質決定は次の処理で構成される。

```
target filter
↓
enemy evolution factor
↓
base quality roll
↓
(optional) research quality shift
↓
quality chain resolution
↓
entity replacement
```

品質段階は  
Quality prototype chain を使用して決定される。

```
normal
↓
uncommon
↓
rare
↓
epic
↓
legendary
```

品質チェーンは runtime prototypes から取得される。

---

# 6. 拡張システム

QFB は次の拡張 Mod に対応する。

| Extension | Effect |
|---|---|
| QFB_MoreQualities | legendary を超える品質段階を解放 |

この拡張が有効な場合、

- 研究 `qfb-biter-quality-shift`
- 研究レベル

に応じて品質段階が拡張される。

---

# 7. 境界と依存関係

QFB は次の前提を持つ。

| System | Responsibility |
|---|---|
| Factorio enemy system | 敵生成・AI |
| Quality system | 品質プロトタイプ定義 |
| Manis_lib | 共通ユーティリティ |

QFB は以下の処理を行わない。

- 敵 AI 行動制御
- 敵 spawn 生成
- ワールド生成制御
- 敵 faction 管理

---

# 8. 決定性

QFB は  
**deterministic random** を使用する。

これにより

- マルチプレイ
- セーブ / ロード
- 再現性

が保証される。

乱数は  
DeterministicRandom によって生成される。

---

# 9. 文書構成

Quality for Biters! は  
現在、最小構成の仕様文書を持つ。

```
00_Overview.md
```

将来、必要に応じて

- Observability
- TestPlan

などの SystemSpecification 文書が追加される可能性がある。

---

# 10. 設計意図

Quality for Biters! は、

> **進化する敵勢力に対して、品質という成長軸を導入する**

ことを目的として設計された。

この Mod は

- 戦闘の多様性
- 敵個体差
- 終盤圧力

を強化することで、

**Factorio の戦闘体験を拡張すること**

を目標としている。

---