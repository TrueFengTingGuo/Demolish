# Demolish
2d Platform game

# Features
- Dialogue box
- Simple reflex agent
- AI Q-learning
- Two swappable weapons
- Three enemies
- Grab hook

# Try It Out
[Download the game](https://github.com/TrueFengTingGuo/Demolish/releases/tag/v1.0.0)


# In Game Footage
- Sneak peak
![](https://github.com/TrueFengTingGuo/Demolish/blob/main/Game%20Demo/game%20demo_3.gif)
- AI Q-learning
  We decided to implement AI in the game in the form of tasks.
After we investigate many games in the market, we found that most AIs don't pick the
optimal solution to achieve a goal. From our observation, the game’s AIs are just simple
reflex agents which only follow fixed policy. One reason that single-player experience is less
compelling compared to multiplayer game mode is that AI is too naive. The AI can perhaps
handle one scenario, but it may not function because the programmer never thought about a
special case. From what we learned in the class, there are many methods that we can
implement into a game, but yet no one seems to want to do it. We came up with a question.
Why does the game's AI neve have any innovation throughout centuries? We couldn’t
understand it. So, We would like to experiment with it ourselves. We decided to add AI to the
game in the form of tasks.

  [Traning footage](https://www.youtube.com/watch?v=0vdAtCa4nFg)
  ![](https://github.com/TrueFengTingGuo/Demolish/blob/main/Game%20Demo/game%20demo_4.gif)
- Character Movement
![](https://github.com/TrueFengTingGuo/Demolish/blob/main/Game%20Demo/Game_demo.gif)
- AI simple reflex agent
![](https://github.com/TrueFengTingGuo/Demolish/blob/main/Game%20Demo/game%20demo_5.gif)

# Contributions 
Fengting Guo:  build game, design Q-learning algorithm, Q-learning algorithm implementation, combine position, participate in writing report
Zhenqing Lang:  Q-learning algorithm implementation (create Q-table, calculate Q-value), agent train, test, participate in writing report
Ziwen Wang:  Q-learning algorithm implementation (reward), agent train,  Modify the rewards based on the test results, participate in writing report
