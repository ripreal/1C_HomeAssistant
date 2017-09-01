package com.ripreal.homeassistant;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Path;
import android.net.Uri;
import android.os.Environment;
import android.support.annotation.NonNull;
import android.view.View;
import android.widget.ImageButton;
import android.widget.LinearLayout;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.UUID;
import android.provider.MediaStore;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.view.View.OnClickListener;
import android.widget.TextView;
import android.widget.Toast;

public class PaintActivity extends AppCompatActivity implements OnClickListener {

    private DrawingView drawView;

    private float smallBrush, mediumBrush, largeBrush;

    private ImageButton currPaint, drawBtn, eraseBtn, openBtn, export1c_btn, contrastBtn, contrastupBtn;

    private final int PICK_IMAGE_REQUEST = 1;

    private float curr_contrast = 1;

    // this is the action code we use in our intent,
    // this way we know we're looking at the response from our own action
    private final int SELECT_PICTURE = 1;

    private Uri uriForExport;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_paint);
        drawView = (DrawingView)findViewById(R.id.drawing);

        // IMPORT FROM 1c
        Bundle bundle = getIntent().getExtras();
        if (bundle != null) {
            Object image = bundle.get("image");
            boolean result = importFromPath(image);
            if (!result)
                importFromUri(image);
        }

        smallBrush = getResources().getInteger(R.integer.small_size);
        mediumBrush = getResources().getInteger(R.integer.medium_size);
        largeBrush = getResources().getInteger(R.integer.large_size);
        drawView.setBrushSize(mediumBrush);

        LinearLayout paintLayout = (LinearLayout)findViewById(R.id.paint_colors);
        currPaint = (ImageButton)paintLayout.getChildAt(0);
        currPaint.setImageDrawable(getResources().getDrawable(R.drawable.paint_pressed));

        eraseBtn = (ImageButton)findViewById(R.id.erase_btn);
        eraseBtn.setOnClickListener(this);

        drawBtn = (ImageButton)findViewById(R.id.draw_btn);
        drawBtn.setOnClickListener(this);

        openBtn = (ImageButton)findViewById(R.id.open_btn);
        openBtn.setOnClickListener(this);

        export1c_btn = (ImageButton)findViewById(R.id.export1c_btn);
        export1c_btn.setOnClickListener(this);

        export1c_btn = (ImageButton)findViewById(R.id.help_btn);
        export1c_btn.setOnClickListener(this);

        contrastBtn = (ImageButton)findViewById(R.id.contrast_btn);
        contrastBtn.setOnClickListener(this);

        contrastupBtn = (ImageButton)findViewById(R.id.contrastup_btn);
        contrastupBtn.setOnClickListener(this);
    }

    public void paintClicked(View view){
        if(view!=currPaint){
            //update color
            ImageButton imgView = (ImageButton)view;
            String color = view.getTag().toString();
            drawView.setColor(color);

            imgView.setImageDrawable(getResources().getDrawable(R.drawable.paint_pressed));
            currPaint.setImageDrawable(getResources().getDrawable(R.drawable.paint));
            currPaint=(ImageButton)view;
        }
    }

    @Override
    public void onClick(View view){
        //respond to clicks
        if(view.getId() == R.id.erase_btn){
            //switch to erase - choose size
            drawView.setErase(true);
        }
        else if (view.getId() == R.id.contrast_btn) {
            curr_contrast++;
            drawView.changeBitmapContrastBrightness(1, -10);
        }
        else if (view.getId() == R.id.contrastup_btn) {
                curr_contrast++;
                drawView.changeBitmapContrastBrightness(1, 10);
        }
        else if(view.getId() == R.id.draw_btn) {
            drawView.setErase(false);

            final Dialog brushDialog = new Dialog(this);
            brushDialog.setTitle("Brush size:");
            brushDialog.setContentView(R.layout.brush_chooser);
            ImageButton smallBtn = (ImageButton)brushDialog.findViewById(R.id.small_brush);
            smallBtn.setOnClickListener(new OnClickListener(){
                @Override
                public void onClick(View v) {
                    drawView.setBrushSize(smallBrush);
                    drawView.setLastBrushSize(smallBrush);
                    brushDialog.dismiss();
                }
            });
            ImageButton mediumBtn = (ImageButton)brushDialog.findViewById(R.id.medium_brush);
            mediumBtn.setOnClickListener(new OnClickListener(){
                @Override
                public void onClick(View v) {
                    drawView.setBrushSize(mediumBrush);
                    drawView.setLastBrushSize(mediumBrush);
                    brushDialog.dismiss();
                }
            });
            ImageButton largeBtn = (ImageButton)brushDialog.findViewById(R.id.large_brush);
            largeBtn.setOnClickListener(new OnClickListener(){
                @Override
                public void onClick(View v) {
                    drawView.setBrushSize(largeBrush);
                    drawView.setLastBrushSize(largeBrush);
                    brushDialog.dismiss();
                }
            });
            brushDialog.show();
        }

        else if (view.getId() == R.id.open_btn) {
            Intent _intent = new Intent();
            _intent.setType("image/*");
            _intent.setAction(Intent.ACTION_GET_CONTENT);
            startActivityForResult(
                    Intent.createChooser(_intent, "Select Picture"),
                    PICK_IMAGE_REQUEST
            );
        }
        else if (view.getId() == R.id.export1c_btn) {
            if (uriForExport != null) {
                drawView.setDrawingCacheEnabled(true);
                try {
                    File file = saveImage(drawView.getDrawingCache(), uriForExport.getPath() +  "_1");
                    String imgSaved = file.getAbsolutePath();
                    if (imgSaved != null) {
                        Toast.makeText(getApplicationContext(), "image saved" + imgSaved, Toast.LENGTH_SHORT).show();
                        Intent intent = new Intent();
                        intent.putExtra("image", imgSaved);
                        setResult(RESULT_OK, intent);
                        finish();
                    }
                } catch (Exception e) {
                    Toast.makeText(getApplicationContext(), "Error during the saving iimage", Toast.LENGTH_SHORT).show();
                    Intent intent = new Intent();
                    setResult(RESULT_CANCELED, intent);
                    finish();
                    e.printStackTrace();
                }
            }
        }
        else if (view.getId() == R.id.help_btn) {
            Intent intent = new Intent(this, AboutActivity.class);
            startActivity(intent);
        }
    }

    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        switch (requestCode) {
            case PICK_IMAGE_REQUEST:
                try {
                    if (data == null)
                        return;
                    Uri uri = data.getData();
                    Bitmap bitmap = MediaStore.Images.Media.getBitmap(getContentResolver(), uri);
                    drawView.setCanvasBitmap(bitmap);
                    drawView.drawBitmap();
                } catch (IOException e) {
                    e.printStackTrace();
                }
        }
   }

    private boolean importFromUri(Object image) {
        boolean success = false;
        try {

            uriForExport = Uri.parse((String) image);

            Bitmap bitmap = MediaStore.Images.Media.getBitmap(getContentResolver(), uriForExport);
            drawView.setCanvasBitmap(bitmap);
            Toast.makeText(getApplicationContext(), "Bitmap from Uri sucess!", Toast.LENGTH_SHORT).show();
            success = true;
        } catch (Exception e) {
            Toast.makeText(getApplicationContext(), "Bitmap from Uri failed!", Toast.LENGTH_SHORT).show();
            e.printStackTrace();

        }
        return success;
    }

    private boolean importFromPath(Object image) {
        boolean success = false;
        try {

            File file = new File((String) image);
            uriForExport =  Uri.fromFile(file);
            Bitmap bitmap = MediaStore.Images.Media.getBitmap(getContentResolver(), uriForExport);
            drawView.setCanvasBitmap(bitmap);
            Toast.makeText(getApplicationContext(), "Bitmap getting from path sucess!", Toast.LENGTH_SHORT).show();
            success = true;
        } catch (Exception e) {
            e.printStackTrace();
            Toast.makeText(getApplicationContext(), "Bitmap getting from path failed!", Toast.LENGTH_SHORT).show();
        }
        return success;
    }

    private File saveImage(Bitmap bitmap, String name) throws IOException {

        // Assume block needs to be inside a Try/Catch block.
        Integer counter = 0;
        File file = new File(name); // the File to save , append increasing numeric counter to prevent files from getting overwritten.
        OutputStream fOut = new FileOutputStream(file);
        bitmap.compress(Bitmap.CompressFormat.PNG, 10, fOut); // saving the Bitmap to a file compressed as a JPEG with 85% compression rate
        fOut.close(); // do not forget to close the stream

        //MediaStore.Images.Media.insertImage(getContentResolver(), file.getAbsolutePath(), file.getName(), file.getName());

        return file;
    }
}