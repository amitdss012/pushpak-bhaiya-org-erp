import { useState, useRef, useEffect } from "react";
import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { useToast } from "@/hooks/use-toast";
import { Camera, Clock, LogOut, CheckCircle } from "lucide-react";
import { format } from "date-fns";

const Attendance = () => {
  const { toast } = useToast();
  const videoRef = useRef<HTMLVideoElement>(null);
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const [isCameraActive, setIsCameraActive] = useState(false);
  const [punchInTime, setPunchInTime] = useState<string | null>(null);
  const [punchOutTime, setPunchOutTime] = useState<string | null>(null);
  const [attendanceStatus, setAttendanceStatus] = useState<"none" | "present" | "completed">("none");
  const [capturedImage, setCapturedImage] = useState<string | null>(null);

  // Request camera permission and start video stream
  const startCamera = async () => {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({
        video: { width: 640, height: 480 },
      });
      
      if (videoRef.current) {
        videoRef.current.srcObject = stream;
        setIsCameraActive(true);
      }
    } catch (error) {
      console.error("Error accessing camera:", error);
      toast({
        title: "Camera Access Denied",
        description: "Please allow camera access to mark attendance",
        variant: "destructive",
      });
    }
  };

  // Stop camera stream
  const stopCamera = () => {
    if (videoRef.current && videoRef.current.srcObject) {
      const tracks = (videoRef.current.srcObject as MediaStream).getTracks();
      tracks.forEach(track => track.stop());
      setIsCameraActive(false);
    }
  };

  // Capture photo and mark attendance
  const capturePhotoAndMarkAttendance = (type: "punch-in" | "punch-out") => {
    if (!videoRef.current || !canvasRef.current) return;

    const video = videoRef.current;
    const canvas = canvasRef.current;
    const context = canvas.getContext("2d");

    if (!context) return;

    // Set canvas dimensions to match video
    canvas.width = video.videoWidth;
    canvas.height = video.videoHeight;

    // Draw current video frame to canvas
    context.drawImage(video, 0, 0, canvas.width, canvas.height);

    // Convert to base64 image
    const imageDataUrl = canvas.toDataURL("image/png");
    setCapturedImage(imageDataUrl);

    const currentTime = new Date();
    const formattedTime = format(currentTime, "yyyy-MM-dd HH:mm:ss");

    if (type === "punch-in") {
      setPunchInTime(formattedTime);
      setAttendanceStatus("present");
      stopCamera();
      
      toast({
        title: "Punch In Successful",
        description: `You have punched in at ${format(currentTime, "HH:mm:ss")}`,
      });
    } else {
      setPunchOutTime(formattedTime);
      setAttendanceStatus("completed");
      stopCamera();
      
      toast({
        title: "Punch Out Successful",
        description: `You have punched out at ${format(currentTime, "HH:mm:ss")}`,
      });
    }
  };

  // Handle punch in
  const handlePunchIn = () => {
    startCamera().then(() => {
      // Wait for camera to start and then capture
      setTimeout(() => {
        capturePhotoAndMarkAttendance("punch-in");
      }, 1000);
    });
  };

  // Handle punch out
  const handlePunchOut = () => {
    startCamera().then(() => {
      setTimeout(() => {
        capturePhotoAndMarkAttendance("punch-out");
      }, 1000);
    });
  };

  // Reset attendance (for demo purposes)
  const resetAttendance = () => {
    setPunchInTime(null);
    setPunchOutTime(null);
    setAttendanceStatus("none");
    setCapturedImage(null);
    stopCamera();
    
    toast({
      title: "Reset Complete",
      description: "Attendance has been reset",
    });
  };

  // Cleanup on unmount
  useEffect(() => {
    return () => {
      stopCamera();
    };
  }, []);

  return (
    <AppLayout>
      <div className="container mx-auto p-6">
        <PageHeader
          title="Mark Attendance"
          description="Mark your daily attendance with live camera photo"
          breadcrumbs={[
            { label: "Attendance", href: "/attendance/mark" },
            { label: "Mark Attendance" },
          ]}
        />

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mt-6">
          {/* Camera Section */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Camera className="h-5 w-5" />
                Live Camera
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="relative bg-muted rounded-lg overflow-hidden aspect-video">
                {isCameraActive ? (
                  <video
                    ref={videoRef}
                    autoPlay
                    playsInline
                    className="w-full h-full object-cover"
                  />
                ) : capturedImage ? (
                  <img
                    src={capturedImage}
                    alt="Captured"
                    className="w-full h-full object-cover"
                  />
                ) : (
                  <div className="flex items-center justify-center h-full text-muted-foreground">
                    <Camera className="h-16 w-16" />
                  </div>
                )}
              </div>
              
              <p className="text-sm text-muted-foreground text-center">
                Your photo will be captured automatically when marking attendance
              </p>

              {/* Hidden canvas for capturing */}
              <canvas ref={canvasRef} className="hidden" />
            </CardContent>
          </Card>

          {/* Attendance Status Section */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Clock className="h-5 w-5" />
                Today's Attendance
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-6">
              {/* Punch In */}
              <div className="space-y-2">
                <div className="flex items-center justify-between">
                  <span className="text-sm font-medium">Punch In</span>
                  {punchInTime ? (
                    <span className="text-sm text-green-600 font-semibold">
                      {format(new Date(punchInTime), "hh:mm a")}
                    </span>
                  ) : (
                    <span className="text-sm text-muted-foreground">Not marked</span>
                  )}
                </div>
                
                <Button
                  onClick={handlePunchIn}
                  disabled={attendanceStatus !== "none" || isCameraActive}
                  className="w-full"
                  size="lg"
                >
                  <CheckCircle className="mr-2 h-4 w-4" />
                  Punch In
                </Button>
              </div>

              {/* Punch Out */}
              <div className="space-y-2">
                <div className="flex items-center justify-between">
                  <span className="text-sm font-medium">Punch Out</span>
                  {punchOutTime ? (
                    <span className="text-sm text-red-600 font-semibold">
                      {format(new Date(punchOutTime), "hh:mm a")}
                    </span>
                  ) : (
                    <span className="text-sm text-muted-foreground">Not marked</span>
                  )}
                </div>
                
                <Button
                  onClick={handlePunchOut}
                  disabled={attendanceStatus === "none" || attendanceStatus === "completed" || isCameraActive}
                  variant="outline"
                  className="w-full"
                  size="lg"
                >
                  <LogOut className="mr-2 h-4 w-4" />
                  Punch Out
                </Button>
              </div>

              {/* Status Indicator */}
              <div className="pt-4 border-t">
                <div className="flex items-center justify-between">
                  <span className="text-sm font-medium">Status</span>
                  <span
                    className={`px-3 py-1 rounded-full text-xs font-semibold ${
                      attendanceStatus === "present"
                        ? "bg-yellow-100 text-yellow-800"
                        : attendanceStatus === "completed"
                        ? "bg-green-100 text-green-800"
                        : "bg-gray-100 text-gray-800"
                    }`}
                  >
                    {attendanceStatus === "none"
                      ? "Not Marked"
                      : attendanceStatus === "present"
                      ? "Present (Punched In)"
                      : "Completed"}
                  </span>
                </div>
              </div>

              {/* Reset Button (Demo only) */}
              {(punchInTime || punchOutTime) && (
                <Button
                  onClick={resetAttendance}
                  variant="ghost"
                  className="w-full text-xs"
                  size="sm"
                >
                  Reset Attendance (Demo)
                </Button>
              )}
            </CardContent>
          </Card>
        </div>

        {/* Instructions Card */}
        <Card className="mt-6">
          <CardHeader>
            <CardTitle>Instructions</CardTitle>
          </CardHeader>
          <CardContent>
            <ul className="list-disc list-inside space-y-2 text-sm text-muted-foreground">
              <li>Click "Punch In" when you arrive to mark your arrival time</li>
              <li>Your photo will be automatically captured using the camera</li>
              <li>Click "Punch Out" when leaving to mark your departure time</li>
              <li>Both punch in and punch out photos are recorded for verification</li>
              <li>Ensure you have proper lighting for clear photo capture</li>
            </ul>
          </CardContent>
        </Card>
      </div>
    </AppLayout>
  );
};

export default Attendance;
