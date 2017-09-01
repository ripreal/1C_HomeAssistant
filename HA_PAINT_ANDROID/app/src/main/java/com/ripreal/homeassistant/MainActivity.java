package com.ripreal.homeassistant;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Environment;
import android.provider.MediaStore;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Toast;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }

    public void PaintButtonOnClick(View view) {
        Intent intent = new Intent(this, PaintActivity.class);
        /*
        Bitmap bitmapSource = BitmapFactory.decodeResource(getResources(), R.drawable.eraser);

        String imgSaved = MediaStore.Images.Media.insertImage(
                getContentResolver(), bitmapSource,
                "my_eraser", "my_eraser");

        intent.putExtra("image", imgSaved);
        */
        startActivityForResult(intent, 1);
    }

    // eport to 1c
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
       if (data == null) {return;}
       String image = data.getStringExtra("image");
       Toast.makeText(getApplicationContext(), "image received" + image, Toast.LENGTH_SHORT).show();
    }

    public File saveImage(String name) throws IOException {

        int[] arr = {255, 250, 150};
        Bitmap bitmap = Bitmap.createBitmap(10, 10, Bitmap.Config.ARGB_8888);
        // Assume block needs to be inside a Try/Catch block.
        String path = Environment.getExternalStorageDirectory().getPath();
        OutputStream fOut = null;
        Integer counter = 0;
        File file = new File(path, name + ".png"); // the File to save , append increasing numeric counter to prevent files from getting overwritten.
        fOut = new FileOutputStream(file);

        bitmap.compress(Bitmap.CompressFormat.PNG, 10, fOut); // saving the Bitmap to a file compressed as a JPEG with 85% compression rate
        fOut.close(); // do not forget to close the stream
        MediaStore.Images.Media.insertImage(getContentResolver(),file.getAbsolutePath(),file.getName(),file.getName());

        return file;
    }
}
