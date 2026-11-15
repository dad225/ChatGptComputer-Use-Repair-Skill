# 浮动蓝图绑定与操作（本机验证 2026-11-02）

## 已通过的操作路径

本机 Codex 26.1027.3384.0、sky 0.7.13，活动 helper 为 local-repair.md 中完整 SHA-256 9D57...F27B 的既有截图/拖拽修复版。20261102-popup-adaptation 的 1DEA...7B13 候选通过隔离测试但现场仍关闭菜单，已撤回，不能安装为成功修复。

直接绑定浮动 `ceshi` 窗口时，输入可能重新激活它，导致恢复尺寸或关闭搜索弹窗。此次有效方法是在原公开接口中绑定已识别的编辑器主 owner 窗口 `ShooterGame - 虚幻编辑器`，由该绑定取得包含 ceshi 和弹窗的最新截图，再使用对应 screenshotId 和截图局部坐标执行。

1. `sky.list_windows()` 枚举当前实际窗口；主窗口与目标浮窗必须对应用户授权的编辑器。唯一选中实际返回对象，通过 `get_window` 重新绑定。不能沿用历史 HWND，也不能仅以同 PID 为理由扩大操作目标。
2. 对主窗口调用 `get_window_state`。检查返回画面是否确实包含目标蓝图/菜单。多个截图时按画面内容识别区域，不能固定使用 `[1]` 或 `[2]`。
3. 输入的 window 使用这个主窗口绑定，screenshotId 使用该次观察返回且包含目标的区域。不能把浮窗绑定的截图 ID 移给主窗口使用。菜单出现后不额外调用 activate_window/Raise。
4. 每个状态相关动作后重新截图，检查菜单内容、焦点、尺寸及结果。拒绝输入或几何错误时刷新观察，不移除窗口归属/前台/坐标保护。该方法是已验证的操作修正，不代表修复了底层所有浮窗激活分支。

## 蓝图具体操作与证据

- **连接**：新截图定位源输出和目标输入引脚，在同一蓝图截图区域用 `sky.drag` 从输出拖到输入。画面出现连线后仍须导出核对双方 LinkedTo。
- **拖动节点**：从节点标题栏向空白位置 `sky.drag`，检查 NodeGuid 对应节点的 NodePosX/Y 实际变化，不能只看光标移动。
- **复制/粘贴**：点击节点标题确认橙色选中边框，再 `Control_L+c`，随后 `Control_L+v`，观察新增节点，必要时拖开副本。导出按 NodeGuid 识别原件/副本：导出节点对象名可能重排；复制后 PinId 可相同，它们由节点与 PinId 共同标识。检查新增活跃节点、不同 NodeGuid、函数/默认值和孤立引脚状态。
- **断线**：用户要求的正确手势是按住 Alt、左键点击要断开的引脚、释放 Alt。必须实际证明这个手势有效。此次仅右键引脚菜单“断开此链接”通过，不能算 Alt+左键通过。
- **编译/保存/重开**：用真实编译按钮确认绿色成功标识；导出核对后 Ctrl+S，仅保存授权测试资产；关闭其标签，从内容浏览器重开，重新导出核对。保留磁盘与活跃导出备份。同进程重开不能叫冷启动包重载。

## Alt+左键：当前未补齐的能力

此 Windows window2 API 的 ClickInput 没有 key/modifiers，PressKeyInput 只发送完整按下/释放序列，未公开 key_down/key_up。已检查本机实际 JS click 实现：只转发 window、x/y、screenshotId、click_count、mouse_button，额外 key 会被忽略。cua_repl 文档也明确 Windows native apps 拒绝 key/durationMs。不能把 Mac/Linux 的参数照搬。

禁止把 `press_key('Alt_L')` 后接 click 写成“Alt+左键”；前一个调用已经释放 Alt。也不能通过全局裸 SendInput、改黏滞键、复用 F24 等无关按键绕过现有窗口/坐标约束。补齐组合输入需要保持目标验证、用户中止、失败清理和按键释放语义的明确实现，再做完整哈希、PE/调用/异常展开、隔离安装回滚及真实 Alt+左键验收。当前未生成或安装这项候选。

## 本次结果位置

`C:/Users/Administrator/.codex/desktop-control-audit/20261102-blueprint/`

- baseline/connected/disconnected/reconnected/pasted/moved/compiled/saved/reopened.copy：各阶段活跃资产导出。
- graph-audit.json：菜单断线、拖动接线、复制粘贴、位置变化、编译保存重开后结构核对。
- environment-after.json：构建、版本、实际路径、签名、全哈希和两程序截图耗时。
- modifier-interface-review.json 与 input-function-*.txt：组合输入接口及原生调用地址的只读取证，不是候选验收。
- asset-backup-before-save：测试蓝图原本尚无正式 uasset，保留已有自动保存二进制及哈希；baseline.copy 保留操作前活跃内容。

编辑器和记事本真实截图、菜单点击、Escape 已通过；连续截图分别 1434/141/135 ms、71/53/50 ms。蓝图搜索弹窗输入/选项点击保持最大化并成功生成节点。未验证 Alt+左键、长时压力、多屏/DPI变化或冷启动。更新可能覆盖原生补丁，必须重新核对完整哈希；本条目不授权未知版本自动修补。
