Pod::Spec.new do |s|
  s.name                  = 'App'
  s.version               = '0.3.0'
  s.summary               = 'Mani SDK App.'
  s.description           = <<-DESC
Mani SDK for authentication to Mani platform
DESC
  s.homepage              = 'https://flutter.dev'
  s.license               = { :type => 'BSD', :text => <<-LICENSE
Copyright 2024 The Mani Authors. All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above
      copyright notice, this list of conditions and the following
      disclaimer in the documentation and/or other materials provided
      with the distribution.
    * Neither the name of Google Inc. nor the names of its
      contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

LICENSE
  }
  s.author                = { 'Mani dev team' => 'rakhmatullaevulmas@gmail.com' }
  s.source        = { :git => 'https://github.com/sudo-ulmas/ManiAppXcFrameworkDebug.git', :tag => "v#{s.version}" }
  s.documentation_url     = 'https://yagona.atlassian.net/wiki/spaces/Mani/pages/71139353/Mani+IOS+SDK+Documentation'
  s.platform              = :ios, '12.0'
  s.ios.vendored_frameworks   = ['App.xcframework']
end

