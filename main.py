import cv2
import os

video_path = '/video'

videos = []


def walk(file):
    global videos

    if os.path.isdir(file):
        for f in os.listdir(file):
            walk(file + '/' + f)
    else:
        if file.endswith('.mp4'):
            videos.append(file)


walk(video_path)


# print(videos)

def get_key_frame(video):
    cap = cv2.VideoCapture(video)
    fps = cap.get(cv2.CAP_PROP_FPS)
    key = int(fps * 5) + 1
    cap.set(cv2.CAP_PROP_POS_FRAMES, key)
    _, frame = cap.read()
    cap.release()
    # cv2.imshow('key_frame', frame)
    # cv2.waitKey(0)
    return frame


for video in videos:
    name = video[:-4] + '.jpg'
    frame = get_key_frame(video)
    cv2.imwrite(name, frame)
    print(name)

if __name__ == '__main__':
    pass
