package in.karkinos.karkinos_mantra_fingerprint;

import android.content.Context;
import android.os.Environment;
import android.util.Log;
import android.widget.Toast;

import com.mantra.mfs100.FingerData;
import com.mantra.mfs100.MFS100;
import com.mantra.mfs100.MFS100Event;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.HashMap;
import java.util.Map;

public class MantraService implements MFS100Event {
    static {
        System.loadLibrary("MFS100V9032");
    }

    private enum ScannerAction {
        Capture, Verify
    }

    byte[] Enroll_Template;
    byte[] Verify_Template;
    private FingerData lastCapFingerData = null;
    ScannerAction scannerAction = ScannerAction.Capture;
    int timeout = 10000;
    MFS100 mfs100 = null;
    private boolean isCaptureRunning = false;

    Context context;

    public MantraService(Context context) {
        this.context=context;
        if (mfs100 == null) {
            mfs100 = new MFS100(this);
            mfs100.SetApplicationContext(context);
        }
    }
    private void SetTextOnUIThread(final String str) {
        Toast.makeText(this.context, str, Toast.LENGTH_LONG).show();
    }


    private void WriteFile(String filename, byte[] bytes) {
        try {
            String path = Environment.getExternalStorageDirectory()
                    + "//FingerData";
            File file = new File(path);
            if (!file.exists()) {
                file.mkdirs();
            }
            path = path + "//" + filename;
            file = new File(path);
            if (!file.exists()) {
                file.createNewFile();
            }
            FileOutputStream stream = new FileOutputStream(path);
            stream.write(bytes);
            stream.close();
        } catch (Exception e1) {
            e1.printStackTrace();
        }
    }

    private byte[] ReadFile(String filename){
        try {
            String path = Environment.getExternalStorageDirectory() + "//FingerData" + "//" + filename;
            File file = new File(path);
            byte[] bytesArray = new byte[(int) file.length()];

            FileInputStream fis = new FileInputStream(file);
            fis.read(bytesArray); //read file into bytes[]
            fis.close();

            return bytesArray;

        } catch (Exception e1) {
            return new byte[0];
        }
    }

    @Override
    public void OnDeviceAttached(int vid, int pid, boolean hasPermission) {

        int ret;
        if (!hasPermission) {
            SetTextOnUIThread("Permission denied");
            return;
        }
        if (vid == 1204 || vid == 11279) {
            if (pid == 34323) {
                ret = mfs100.LoadFirmware();
                if (ret != 0) {
                    SetTextOnUIThread(mfs100.GetErrorMsg(ret));
                } else {
                    SetTextOnUIThread("Load firmware success");
                }
            } else if (pid == 4101) {
                String key = "Without Key";
                ret = mfs100.Init();
                if (ret == 0) {
                    SetTextOnUIThread("device attached");
                } else {
                    SetTextOnUIThread(mfs100.GetErrorMsg(ret));
                }
            }
        }
    }

    @Override
    public void OnDeviceDetached() {
        SetTextOnUIThread("Device removed");
    }

    @Override
    public void OnHostCheckFailed(String err) {
        try {
            SetTextOnUIThread("on host check failed error");
        } catch (Exception ignored) {
        }
    }

    //futter method
    public void InitScanner() {
        try {
            int ret = mfs100.Init();
            if (ret != 0) {
                SetTextOnUIThread(mfs100.GetErrorMsg(ret));
            } else {
                SetTextOnUIThread("Init success");
                String info = "Serial: " + mfs100.GetDeviceInfo().SerialNo()
                        + " Make: " + mfs100.GetDeviceInfo().Make()
                        + " Model: " + mfs100.GetDeviceInfo().Model()
                        + "\nCertificate: " + mfs100.GetCertification();
                Log.i("karkinos_mantra",info);
            }
        } catch (Exception ex) {
            SetTextOnUIThread("Init failed, unhandled exception");
        }
    }

    private void compareFingerPrintByISO(final String isoFileName,SuccessCallback successCallback,ErrorCallback errorCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                isCaptureRunning = true;
                try {
                    FingerData fingerData = new FingerData();
                    final int ret = mfs100.AutoCapture(fingerData, timeout,false);
                    if (ret != 0) {
                        errorCallback.onResult(mfs100.GetErrorMsg(ret));
                    } else {
                        //Capture Success

                        byte[] confingeriso = ReadFile(isoFileName);
                        int ret1 = mfs100.MatchISO(confingeriso,fingerData.ISOTemplate());
                        if(ret1 > 1400 ){
                            successCallback.onResult("matched");
                        }else{
                            successCallback.onResult("un-matched");
                        }
                    }
                } catch (Exception ex) {
                    SetTextOnUIThread("Error");
                    errorCallback.onResult("failure");
                } finally {
                    isCaptureRunning = false;
                }
            }
        }).start();
    }
    public void StartSyncCapture(SuccessCallback successCallback,ErrorCallback errorCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                isCaptureRunning = true;
                try {
                    FingerData fingerData = new FingerData();
                    final int ret = mfs100.AutoCapture(fingerData, timeout,false);
                    if (ret != 0) {
                        throw new Exception(mfs100.GetErrorMsg(ret));
                    } else {

                        long unixTime = System.currentTimeMillis() / 1000L;
                        String filename = unixTime+"fingerISO.iso";
                        WriteFile(filename,fingerData.ISOTemplate());
                        successCallback.onResult(filename);
                        //successCallback.invoke(filename);
                    }
                } catch (Exception ex) {
                    SetTextOnUIThread("Error");
                    errorCallback.onResult("Error");
                } finally {
                    isCaptureRunning = false;
                }
            }
        }).start();
    }
}
