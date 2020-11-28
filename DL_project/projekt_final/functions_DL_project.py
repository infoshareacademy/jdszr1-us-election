import tensorflow as tf
import ipywidgets as widgets
from IPython.display import display
import io
from PIL import Image
import face_recognition_models as fs
from skimage import color
import numpy as np
import cv2
import matplotlib.pyplot as plt


uploader = widgets.FileUpload()
display(uploader)
button = widgets.Button(description="Run")
display(button)

# do resajzu zdjęcia z zewnątrz, do wymiarów, na których były trenowane modele
desired_size = 48

# model rozpoznawania wieku
model_age = tf.keras.models.load_model('models/model_age_all')
# model rozpoznawania płci
model_gender = tf.keras.models.load_model('models/history07_gender')
# słownik dotyczący płci
labels = ['mezczyzna', 'kobieta']

def on_button_clicked(b): 
    content = uploader.value.get(list(uploader.value)[0]).get('content')
    img_first = Image.open(io.BytesIO(content))
#     display(img_first)
    
    # PIL image object to numpy array
    img_arr = np.asarray(img_first)      
#     print('img shape', img_arr.shape)
#     display(img_arr)
    img_resize = cv2.resize(img_arr, (desired_size,)*2).astype('uint8')
#     display(f'Typ img_resize: {img_resize}')
    
    try:
        img_gray = cv2.cvtColor(img_resize, cv2.COLOR_RGB2GRAY)
    except Exception:
        img_gray = color.rgb2gray(img_resize) 

    # img_gray = color.rgb2gray(img_resize) 
                #cv2.cvtColor(img_resize, cv2.COLOR_RGB2GRAY)
    #     display(f'Typ img_gray: {img_gray}')

    img_gray_flat = [x for sets in img_gray for x in sets]
    
    # testy zmiany danych:
#     print("np.array(img_gray_flat).shape")
#     display(np.array(img_gray_flat).shape)
#     print("str(img_gray_flat)")
#     display(str(img_gray_flat))
#     print("np.array(img_gray_flat)")
#     display(np.array(img_gray_flat))
    
    # przygotowanie x do modelu wieku
    img_gray_flat_norm = np.array(img_gray_flat) / 255.0
    img_gray_flat_norm_float = img_gray_flat_norm.astype(np.float32)
    img_final_age = img_gray_flat_norm_float.reshape(1,48,48,1)    
    
    
    # wyświetlanie zdjęć
    fig, (ax_0, ax_1) = plt.subplots(nrows=1, ncols=2, figsize=(12,12))
    ax_0.imshow(img_first)
    ax_0.set_title("img_first")
    ax_1.imshow(img_gray)
    ax_1.set_title("img_gray")
    plt.show()
 
    # przygotowanie x do modelu płci
    
    img_gray_flat_gender = np.array(img_gray_flat)
    img_gray_flat_gender = img_gray_flat_gender.reshape(1, 48, 48, 1)
    img_gray_flat_gender_final = int(np.argmax(model_gender(img_gray_flat_gender), axis=1))
    
    # modele sprawdzające płeć i wiek
    y_final_gender = labels[img_gray_flat_gender_final]
    print(f"Płeć wg. modelu: {y_final_gender}")
    y_fianl_age = int(model_age.predict(img_final_age))
    print(f"Wiek prognozowany: {y_fianl_age} lat/a.")


button.on_click(on_button_clicked)
uploader.value