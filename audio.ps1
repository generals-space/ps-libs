<#
function: 定义并添加音量控制API
参考文章
1. [powershell脚本设置电脑音量](https://blog.csdn.net/yolo3/article/details/81118320)
2. [PowerShell 技能连载 - 控制音量（静音和音量）](https://blog.vichamp.com/2017/08/23/controlling-audio-mute-and-volume/)
#>
function InitAudioAPI {
$TypeDefinition = @"
    using System;
    using System.Runtime.InteropServices;

    namespace Sound
    {
        [Guid("5CDF2C82-841E-4546-9722-0CF74078229A"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]

        interface IAudioEndpointVolume
        {
            // f(), g(), ... are unused COM method slots. Define these if you care
            int f(); int g(); int h(); int i();
            int SetMasterVolumeLevelScalar(float fLevel, System.Guid pguidEventContext);
            int j();
            int GetMasterVolumeLevelScalar(out float pfLevel);
            int k(); int l(); int m(); int n();
            int SetMute([MarshalAs(UnmanagedType.Bool)] bool bMute, System.Guid pguidEventContext);
            int GetMute(out bool pbMute);
        }

        [Guid("D666063F-1587-4E43-81F1-B948E807363F"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]

        interface IMMDevice
        {
            int Activate(ref System.Guid id, int clsCtx, int activationParams, out IAudioEndpointVolume aev);
        }

        [Guid("A95664D2-9614-4F35-A746-DE8DB63617E6"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]

        interface IMMDeviceEnumerator
        {
            int f(); // Unused
            int GetDefaultAudioEndpoint(int dataFlow, int role, out IMMDevice endpoint);
        }

        [ComImport, Guid("BCDE0395-E52F-467C-8E3D-C4579291692E")] class MMDeviceEnumeratorComObject { }

        public class Audio
        {
            static IAudioEndpointVolume Vol()
            {
                IMMDeviceEnumerator enumerator = new MMDeviceEnumeratorComObject() as IMMDeviceEnumerator;
                IMMDevice dev = null;
                Marshal.ThrowExceptionForHR(enumerator.GetDefaultAudioEndpoint(/*eRender*/ 0, /*eMultimedia*/ 1, out dev));
                IAudioEndpointVolume epv = null;
                Guid epvid = typeof(IAudioEndpointVolume).GUID;
                Marshal.ThrowExceptionForHR(dev.Activate(ref epvid, /*CLSCTX_ALL*/ 23, 0, out epv));
                return epv;
            }
            public static float Volume
            {
                get { 
                    float v = -1; 
                    Marshal.ThrowExceptionForHR(Vol().GetMasterVolumeLevelScalar(out v)); 
                    return v; 
                }
                set { 
                    Marshal.ThrowExceptionForHR(Vol().SetMasterVolumeLevelScalar(value, System.Guid.Empty)); 
                }
            }
            public static bool Mute
            {
                get { 
                    bool mute; 
                    Marshal.ThrowExceptionForHR(Vol().GetMute(out mute)); 
                    return mute; 
                }
                set { 
                    Marshal.ThrowExceptionForHR(Vol().SetMute(value, System.Guid.Empty)); 
                }
            }
        }
    }
"@;
Add-Type $TypeDefinition;
}

InitAudioAPI;

<#
function: 设置音量值, 范围1-100
#>
function GetVolume {
    ## 格式化输出数值, 不输出小数点后面的部分.
    '{0:n0}' -f ([Sound.Audio]::Volume * 100);
}

<#
function: 设置音量值, 范围1-100
#>
function SetVolume {
    param
    (
        [Parameter(Mandatory = $true, Position = 0)] [int] $SndVol
    )
    [Sound.Audio]::Volume = ($SndVol/100);
}

<#
function: 静音操作
#>
function Mute {
    ## $TypeDefinition = (GetAudioAPIType)
    [Sound.Audio]::Mute = $true
}

<#
function: 解除静音
#>
function UnMute {
    [Sound.Audio]::Mute = $false
}
