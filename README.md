# PingPong App

## Description:
An IOS app that simulates bouncing a ball on a ping pong paddle, using the phone’s Gyroscope, Accelerometer, altitude, and location sensors. This can transform every sport with a ball into a playing anywhere only with your phones. Currently in early stage development and proof of concept. 

## The Architecture:

Using Apple’s CoreMotion library, the app extracts information like Gyroscope, Accelerometer, and RPY, the app can detect the movement of the phone. The app uses physics equations, and the strength and direction of the user’s bounce to simulate an accurate ball trajectory. The ball can be bounced all over the phone’s screen, and with natural rotations the user can move it to the desired location, just bouncing a physical ball. 

## Built With
- Swift
- StoryBoard
- CoreMotion
