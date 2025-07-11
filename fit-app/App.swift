import SwiftUI

@main
struct bznZq23oqpIdNqA1wbzgsmcc11mjbUC2: App {
    @StateObject private var FfMlKSdN0VvNsKLTaCk5aNVKbSS4yOqT = M8vqmFyXCG9Rq6KAMpOqYJzLdBbuMBhB()
    @StateObject private var KMRiwmU3CUg6bO2vZUrAbz5IK07uMatr = c3kqQniNesZXpxTzJtrm9NMyH8bXfWx7.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX
    @StateObject private var Tt3J2okrS5M6N0tpQWlXnaQtSfKrGrp9 = gcAHxRIJfz72aGUGGNJZgmaSXybR0xrm.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX
    
    private var Eipluq8LD9geJrV1Io29kimcg2nhUc0k: Bool {
        UserDefaults.standard.bool(forKey: "hasSeenWelcome")
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if FfMlKSdN0VvNsKLTaCk5aNVKbSS4yOqT.ZcyV56DImmWj4Y96j2b459YI8SvPQpMA {
                    // Show goodbye screen during logout process
                    ApJ08JFGfVrR1tOMiHbVWMDwIafd73iX()
                        .environmentObject(FfMlKSdN0VvNsKLTaCk5aNVKbSS4yOqT)
                        .environmentObject(Tt3J2okrS5M6N0tpQWlXnaQtSfKrGrp9)
                        .preferredColorScheme(.dark)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                } else if FfMlKSdN0VvNsKLTaCk5aNVKbSS4yOqT.exTCxBz8yvnNYRQqFWC1W0Yh5tEaeJAH {
                    if Eipluq8LD9geJrV1Io29kimcg2nhUc0k {
                        // Returning user - go directly to main app
                        ZStack {
                            KQMbB3ZqQUMbSR2AGsJpCknS8pSLtpb6()
                                .environmentObject(FfMlKSdN0VvNsKLTaCk5aNVKbSS4yOqT)
                                .environmentObject(KMRiwmU3CUg6bO2vZUrAbz5IK07uMatr)
                                .environmentObject(Tt3J2okrS5M6N0tpQWlXnaQtSfKrGrp9)
                                .preferredColorScheme(.dark)
                            
                            isqjtgeChdmyuavMEwRRyV8yoeHAhS9Z()
                                .environmentObject(KMRiwmU3CUg6bO2vZUrAbz5IK07uMatr)
                        }
                        .onAppear {
                            // Set default username if not already set in secure storage
                            do {
                                if try HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.eXGEhDZR5F3a9M8RnmLQbPuTTK0QyTsR(HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd) == nil {
                                    try HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.r0AqoYxLhfNYCN9Nib0HLfzhDAmXp8ry("Antonio", for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd)
                                }
                            } catch {
                                // Fallback to legacy method
                                if HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.UwCfOvdiEB0JykxJZrQyJ9j9gpHY8v8T(for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd) == nil {
                                    _ = HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.DXPhOdciSwPjsN1KvFiEAYkiEIW53RAX.GpX2gmw5MvTjIh4UaeYUjQdWdoMsVBcp("Antonio", for: HXLVXCYNs3KrYvdcOPdd8IWNdGGPQRow.JPsFJ6NTFsGAmXupFfYpO1PI5ArmDRGB.YhyL54l7qYGd78Z7egtPFzCWzLff1uDd)
                                }
                            }
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    } else {
                        // First-time user - show welcome screen
                        FODJtP74PgH7G1Dvz9bqZM4YTVIu3AY0()
                            .environmentObject(FfMlKSdN0VvNsKLTaCk5aNVKbSS4yOqT)
                            .environmentObject(Tt3J2okrS5M6N0tpQWlXnaQtSfKrGrp9)
                            .preferredColorScheme(.dark)
                            .transition(.scale.combined(with: .opacity))
                    }
                } else {
                    wdJa7hhtRa6I67ei2Mi07KjELvqym68b()
                        .environmentObject(FfMlKSdN0VvNsKLTaCk5aNVKbSS4yOqT)
                        .environmentObject(Tt3J2okrS5M6N0tpQWlXnaQtSfKrGrp9)
                        .preferredColorScheme(.dark)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .animation(.easeInOut(duration: 0.5), value: FfMlKSdN0VvNsKLTaCk5aNVKbSS4yOqT.exTCxBz8yvnNYRQqFWC1W0Yh5tEaeJAH)
            .animation(.easeInOut(duration: 0.7), value: Eipluq8LD9geJrV1Io29kimcg2nhUc0k)
            .animation(.easeInOut(duration: 0.5), value: FfMlKSdN0VvNsKLTaCk5aNVKbSS4yOqT.ZcyV56DImmWj4Y96j2b459YI8SvPQpMA)
        }
    }
}
