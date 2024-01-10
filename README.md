# Camera Trainer

This is an iPhone app designed to permit the fast labling of video clips in order to generate training data for experiments with machine learning. Since a good dataset is large, UI speed is essential so this app is strictly no-frills.

## Workflow

A user is presented with a video clip and a list of previously used labels. If a suitable label is not shown, a new one can be added. 

Once the desired set of labels are selected, the user swipes from the right to get a new video clip, which implicitly posts labels to the [backend](https://github.com/tomwhipple/camera-watcher).
