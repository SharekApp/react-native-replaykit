//  Created by Giridhar on 09/06/17.
//  MIT Licence.
//  Modified By: [
//  Matt Thompson 9/14/18
//]

import Foundation
import ReplayKit
import AVKit



@objc class ScreenRecorder:NSObject
{
    var assetWriter:AVAssetWriter!
    var videoInput:AVAssetWriterInput!

    let viewOverlay = WindowUtil()

    //MARK: Screen Recording
    public func startRecording(withFileName fileName: String, recordingHandler:@escaping (Error?)-> Void)
    {
        if #available(iOS 11.0, *)
        {
            let fileURL = URL(fileURLWithPath: ReplayFileUtil.filePath(fileName))
            assetWriter = try! AVAssetWriter(outputURL: fileURL, fileType:
                AVFileType.mp4)
            let videoOutputSettings: Dictionary<String, Any> = [
                AVVideoCodecKey : AVVideoCodecType.h264,
                AVVideoWidthKey : UIScreen.main.bounds.width,
                AVVideoHeightKey : UIScreen.main.bounds.height
            ];
            
            videoInput  = AVAssetWriterInput (mediaType: AVMediaType.video, outputSettings: videoOutputSettings)
            videoInput!.expectsMediaDataInRealTime = true
            assetWriter?.add(videoInput!)
            let recorder = RPScreenRecorder.shared()
            guard recorder.isAvailable else {
                print("ReplayKit: recorder not available")
                return }
            
            recorder.startCapture(handler: { (sample, bufferType, error) in
                
                recordingHandler(error)
                
                switch bufferType {
                case .video:
                    //print("ReplayKit: writing sample....");

                    switch self.assetWriter!.status {
                    case .unknown:
                        if self.assetWriter?.startWriting != nil {
                            print("ReplayKit: Starting writing")

                            self.assetWriter!.startWriting()
                            self.assetWriter!.startSession(atSourceTime:  CMSampleBufferGetPresentationTimeStamp(sample))
                        }
                        
                    case .writing:
                        if self.videoInput!.isReadyForMoreMediaData {
                            //print("ReplayKit: Writing a sample")
                            
                            if  self.videoInput!.append(sample) == false {
                                print("ReplayKit: we have a problem writing video")
                            }
                        }
                    default: break
                    }

                default:
                    print("ReplayKit: not a video sample, so ignore");
                }
                
                
            }) { (error) in
                recordingHandler(error)
                debugPrint(error)
            }
        } else
        {
            // Fallback on earlier versions
        }
    }

    public func stopRecording(handler: @escaping (Error?) -> Void)
    {
        if #available(iOS 11.0, *)
        {
            RPScreenRecorder.shared().stopCapture { (Error) in
                self.assetWriter.finishWriting {
                    print(ReplayFileUtil.fetchAllReplays())
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }




}


