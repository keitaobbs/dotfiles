package sample.activity;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.PerformanceHintManager;
import android.os.PowerManager;
import android.text.method.ScrollingMovementMethod;
import android.util.Log;
import android.widget.Button;
import android.widget.TextView;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.concurrent.Executors;
import java.util.concurrent.ExecutorService;

public class SampleActivity extends Activity {
    private static final String TAG = SampleActivity.class.getSimpleName();
    private ArrayList<Button> mButtons = new ArrayList<Button>();
    private StringBuilder mTextStringBuilder = new StringBuilder();
    private TextView mMainTv = null;

    private void resetButtonCallback(Handler handler) {
        mTextStringBuilder.setLength(0);
        updateView(handler);
        handler.post(() -> enableButtons());
    }

    private void adpfButtonCallback(Handler handler) {
        logI("=== ADPF ===");

        int[] tids = {
            android.os.Process.myTid()
        };

        logI("Thread IDs: " + Arrays.toString(tids));

        long startTimeNanos = System.nanoTime();

        long targetDurationNanos = 1000 * 1000 * 10; // 10 ms
        PerformanceHintManager performanceHintManager =
                (PerformanceHintManager) this.getSystemService(Context.PERFORMANCE_HINT_SERVICE);
        PerformanceHintManager.Session hintSession =
                performanceHintManager.createHintSession(tids, targetDurationNanos);

        long endTimeNanos = System.nanoTime();
        long actualDurationNanos = endTimeNanos - startTimeNanos;
        hintSession.reportActualWorkDuration(actualDurationNanos);

        logI("targetDurationNanos: " + targetDurationNanos);
        logI("actualDurationNanos: " + actualDurationNanos);

        int forecastSeconds = 10;
        PowerManager powerManager = (PowerManager) this.getSystemService(Context.POWER_SERVICE);
        float thermalHeadroom = powerManager.getThermalHeadroom(forecastSeconds);
        int thermalStatus = powerManager.getCurrentThermalStatus();

        logI("ThermalHeadroom in " + forecastSeconds + " sec: " + thermalHeadroom);
        logI("Current ThermalStatus: " + thermalStatus);

        updateView(handler);
        handler.post(() -> enableButtons());
    }

    private void enableButtons() {
        for (Button btn : mButtons) {
            btn.setEnabled(true);
        }
    }

    private void disableButtons() {
        for (Button btn : mButtons) {
            btn.setEnabled(false);
        }
    }

    private void updateView() {
        updateView(null);
    }

    private void updateView(Handler handler) {
        if (handler != null) {
            handler.post(() -> mMainTv.setText(mTextStringBuilder));
        } else {
            mMainTv.setText(mTextStringBuilder);
        }
    }

    private void addText(String text) {
        mTextStringBuilder.append(text);
        mTextStringBuilder.append("\n");
    }

    private void logI(String msg) {
        addText(msg);
        Log.i(TAG, msg);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.main);

        Button button;

        button = findViewById(R.id.adpf_button);
        button.setOnClickListener(v -> {
            disableButtons();
            ExecutorService executor = Executors.newSingleThreadExecutor();
            Handler handler = new Handler(Looper.getMainLooper());
            executor.execute(() -> adpfButtonCallback(handler));
        });
        mButtons.add(button);

        button = findViewById(R.id.reset_button);
        button.setOnClickListener(v -> {
            disableButtons();
            ExecutorService executor = Executors.newSingleThreadExecutor();
            Handler handler = new Handler(Looper.getMainLooper());
            executor.execute(() -> resetButtonCallback(handler));
        });
        mButtons.add(button);

        mMainTv = findViewById(R.id.main_text_view);
        mMainTv.setMovementMethod(ScrollingMovementMethod.getInstance());

        updateView();
    }
}
