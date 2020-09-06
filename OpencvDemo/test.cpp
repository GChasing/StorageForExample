#include <iostream>
#include <chrono>
using namespace std;
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/core/core.hpp>

int main(int argc, char** argv)
{
    cv::Mat image;
    image = cv::imread("ubuntu.png");
    if(image.data == nullptr){
        cerr<<argv[1]<<"unexisted!"<<endl;
        return 0;
    }
    cout<<image.cols<<"\t"<<image.rows<<endl;
    cv::imshow("image",image);
    cv::waitKey(0);

    return 1;
}